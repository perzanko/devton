defmodule DevtonAggregator.ArticlesAggregator do
  require Logger
  use GenServer

  alias Devton.Library

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(initial_value) do
    {:ok, initial_value}
  end

  def handle_cast({:aggregate_single, tag, index}, state) do
    spawn(
      fn ->
        Logger.info("ArticlesAggregator, aggregating: #{tag}")
        try do
          result = HTTPoison.get!("https://dev.to/api/articles?top=5&tag=#{tag}").body
          |> Poison.decode!
          GenServer.cast(__MODULE__, {:save_result, result})
        rescue
          _ -> []
        end
      end
    )
    {:noreply, state}
  end

  def handle_cast({:save_result, result}, state) do
    spawn(
      fn ->
        Enum.each(
          result,
          fn article ->
            Library.create_article article
          end
        )
      end
    )
    {:noreply, state}
  end

  def handle_info({_, result}, state) do
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}

  def aggregate() do
    Logger.info("ArticlesAggregator start aggregate")
    spawn(
      fn ->
        Library.find_tags
        |> Stream.with_index
        |> Enum.each(
             fn {tag, index} ->
               :timer.sleep(200)
               GenServer.cast(__MODULE__, {:aggregate_single, tag, index})
             end
           )
      end
    )
  end
end
