defmodule Devton.Library.Aggregates.Article do
  defstruct id: nil,
            type_of: nil,
            title: nil,
            description: nil,
            cover_image: nil,
            published_at: nil,
            published_timestamp: nil,
            slug: nil,
            path: nil,
            url: nil,
            canonical_url: nil,
            comments_count: nil,
            positive_reactions_count: nil,
            tag_list: [],
            user: %{},
            organization: %{}

  alias __MODULE__

  alias Devton.Library.Commands.{
    CreateArticle,
    }
  alias Devton.Library.Events.{
    ArticleCreated
    }

  def execute(
        %Article{},
        %CreateArticle{} = create_article
      ) do
    %ArticleCreated{
      id: create_article.id,
      type_of: create_article.type_of,
      title: create_article.title,
      description: create_article.description,
      cover_image: create_article.cover_image,
      published_at: create_article.published_at,
      published_timestamp: create_article.published_timestamp,
      slug: create_article.slug,
      path: create_article.path,
      url: create_article.url,
      canonical_url: create_article.canonical_url,
      comments_count: create_article.comments_count,
      positive_reactions_count: create_article.positive_reactions_count,
      tag_list: create_article.tag_list,
      user: create_article.user,
      organization: create_article.organization
    }
  end

  #  state mutators

  def apply(
        %Article{} = article,
        %ArticleCreated{} = article_created
      ) do
    %Article{
      article |
      id: article_created.id,
      type_of: article_created.type_of,
      title: article_created.title,
      description: article_created.description,
      cover_image: article_created.cover_image,
      published_at: article_created.published_at,
      published_timestamp: article_created.published_timestamp,
      slug: article_created.slug,
      path: article_created.path,
      url: article_created.url,
      canonical_url: article_created.canonical_url,
      comments_count: article_created.comments_count,
      positive_reactions_count: article_created.positive_reactions_count,
      tag_list: article_created.tag_list,
      user: article_created.user,
      organization: article_created.organization
    }
  end
end
