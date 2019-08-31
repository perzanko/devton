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
    Task.async(
      fn ->
        :timer.sleep(index * 100)
        Logger.info("ArticlesAggregator, aggregating: #{tag}")
        try do
          HTTPoison.get!("https://dev.to/api/articles?top=5&tag=#{tag}").body
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
      fn article ->
        Library.create_article article
      end
    )
    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}

  def aggregate() do
    Logger.info("ArticlesAggregator start aggregate")
    Library.find_tags
    |> Stream.with_index
    |> Enum.each(
         fn {tag, index} ->
           Task.async fn -> GenServer.cast(__MODULE__, {:aggregate_single, tag, index}) end
         end
       )
  end
end
