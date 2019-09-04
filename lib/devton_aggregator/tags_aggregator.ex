defmodule DevtonAggregator.TagsAggregator do
  require Logger
  use GenServer

  alias Devton.Library

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_cast({:aggregate_single, page_id}, state) do
    spawn(
      fn ->
        Logger.info("TagsAggregator, aggregating: #{page_id}")
        try do
          HTTPoison.get!("https://dev.to/api/tags?page=#{page_id}").body
          |> Poison.decode!
        rescue
          _ -> []
        end
      end
    )
    {:noreply, state}
  end

  def handle_info({_, result}, state) do
    Enum.each(
      result,
      fn tag ->
        Library.create_tag tag
      end
    )
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}

  def aggregate() do
    Logger.info("TagsAggregator start aggregate")
    spawn(
      fn ->
        Enum.each(
          1..4000,
          fn x ->
            :timer.sleep(200)
            GenServer.cast(__MODULE__, {:aggregate_single, x})
          end
        )
      end
    )
  end
end
