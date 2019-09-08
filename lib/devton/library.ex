defmodule Devton.Library do
  @moduledoc false

  use Timex

  import Ecto.Query, only: [from: 2]

  alias Devton.Repo
  alias Devton.Router
  alias Devton.Library.Commands.{CreateTag, CreateArticle}
  alias Devton.Library.Projections.{Tag, Article, TopTag}

  def get_article(%{ "id" => id }) do
    case Repo.get(Article, id) do
      %Article{} = article ->
        {:ok, article}
      _ ->
        {:error, :not_found}
    end
  end

  def create_tag(tag, metadata \\ %{}) do
    result =
      %CreateTag{
        id: tag["id"],
        name: tag["name"],
        bg_color_hex: tag["bg_color_hex"],
        text_color_hex: tag["text_color_hex"],
      }
      |> Router.dispatch(metadata: metadata)

    case result do
      :ok ->
        {
          :ok,
          %Tag{id: tag["id"]}
        }
      reply ->
        reply
    end
  end

  def create_article(article, metadata \\ %{}) do
    result =
      %CreateArticle{
        id: article["id"],
        type_of: article["type_of"],
        title: article["title"],
        description: article["description"],
        cover_image: article["cover_image"],
        published_at: article["published_at"],
        published_timestamp: article["published_timestamp"],
        slug: article["slug"],
        path: article["path"],
        url: article["url"],
        canonical_url: article["canonical_url"],
        comments_count: article["comments_count"],
        positive_reactions_count: article["positive_reactions_count"],
        tag_list: article["tag_list"] || [],
        user: article["user"] || %{},
        organization: article["organization"] || %{}
      }
      |> Router.dispatch(%{metadata: metadata})

    case result do
      :ok ->
        {
          :ok,
          %Article{id: article["id"]}
        }
      reply ->
        reply
    end
  end

  def find_tags() do
    query = from t in Tag, select: t.name
    Repo.all query
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
                 limit: 50
    Repo.all query
  end

  def get_top_tags(top \\ 20) do
    query = from tt in TopTag,
      select: [tt.tag_name, count(tt.id)],
      limit: ^top,
      order_by: [desc: count(tt.id)],
      group_by: tt.tag_name
    Repo.all(query)
    |> Enum.map(fn [tag_name, count] -> %{ tag_name: tag_name, count: count } end)
  end
end
