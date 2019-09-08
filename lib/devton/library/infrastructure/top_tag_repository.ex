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
end
