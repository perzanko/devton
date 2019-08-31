defmodule Devton.Library do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Devton.Repo
  alias Devton.Router
  alias Devton.Library.Commands.{CreateTag, CreateArticle}
  alias Devton.Library.Projections.{Tag, Article}

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
      |> Router.dispatch(metadata: metadata)

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
end
