defmodule Devton.Library.Repositories.ArticleRepository do

  import Ecto.Query, only: [from: 2]
  import Ecto.Query

  alias Devton.Repo
  alias Devton.Library.Projections.Article


  def find_one(id) do
    Repo.get(Article, id)
  end

  def get_suggested_articles(tags) do
    query = "
      SELECT * from article a
      WHERE a.published_at > '#{
      Timex.now()
      |> Timex.shift(days: -5)
      |> DateTime.to_iso8601
    }'
      AND (#{
      tags
      |> Enum.map(fn tag -> "'#{tag}' = ANY(a.tag_list)" end)
      |> Enum.join(" OR ")
    })
      ORDER BY a.positive_reactions_count DESC
      LIMIT 50
    "

    result = Ecto.Adapters.SQL.query!(Repo, query)
    Enum.map(result.rows, &Repo.load(Article, {result.columns, &1}))
  end

  def get_suggested_articles() do
    query = from a in Article,
                 order_by: [
                   desc: a.positive_reactions_count
                 ],
                 where: a.published_at > ^Timex.shift(Timex.now(), days: -5),
                 limit: 100
    Repo.all query
  end
end
