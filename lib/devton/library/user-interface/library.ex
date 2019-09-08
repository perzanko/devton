defmodule Devton.Library do
  @moduledoc false

  use Timex

  alias Devton.Library.Repositories.TagRepository
  alias Devton.Library.Repositories.TopTagRepository
  alias Devton.Library.Repositories.ArticleRepository

  alias Devton.Router
  alias Devton.Library.Commands.{CreateTag, CreateArticle}
  alias Devton.Library.Projections.{Tag, Article, TopTag}

#  Query

  def get_article(%{ "id" => id }) do
    case ArticleRepository.find_one(id) do
      %Article{} = article ->
        {:ok, article}
      _ ->
        {:error, :not_found}
    end
  end

  def find_tags() do
    TagRepository.find_all()
  end

  def get_suggested_articles(tags) do
    ArticleRepository.get_suggested_articles(tags)
  end

  def get_suggested_articles() do
    ArticleRepository.get_suggested_articles()
  end

  def get_top_tags(top) do
    TopTagRepository.find_all(top)
  end

#  Command

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
end
