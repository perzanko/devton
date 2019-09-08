defmodule Devton.Library.Repositories.TopTagRepository do

  import Ecto.Query, only: [from: 2]
  import Ecto.Query

  alias Devton.Repo
  alias Devton.Library.Projections.TopTag


  def find_all(limit \\ 20) do
    query = from tt in TopTag,
                 select: [tt.tag_name, count(tt.id)],
                 limit: ^limit,
                 order_by: [
                   desc: count(tt.id)
                 ],
                 group_by: tt.tag_name
    Repo.all(query)
    |> Enum.map(fn [tag_name, count] -> %{tag_name: tag_name, count: count} end)
  end

  def find_by_names(tag_list) do
    query = from tt in TopTag,
                 select: [tt.tag_name, count(tt.id)],
                 where: tt.tag_name in ^tag_list,
                 order_by: [
                   desc: count(tt.id)
                 ],
                 group_by: tt.tag_name
    Repo.all(query)
    |> Enum.map(fn [tag_name, count] -> %{tag_name: tag_name, count: count} end)
    |> Enum.reduce(
         tag_list
         |> Enum.map(fn x -> Map.new([{x, 0}]) end)
         |> Enum.reduce(%{}, fn x, acc -> Map.merge(acc, x) end),
         fn %{tag_name: tag_name, count: count}, acc -> Map.replace!(acc, tag_name, count) end
       )
  end
end
