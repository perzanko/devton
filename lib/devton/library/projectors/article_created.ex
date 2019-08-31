defmodule Devton.Library.Projectors.ArticleCreated do
  use Commanded.Projections.Ecto, name: "Library.Projectors.ArticleCreated"

  alias Devton.Repo
  alias Devton.Library.Events.ArticleCreated
  alias Devton.Library.Projections.Article

  project(
    %ArticleCreated{} = event,
    _metadata,
    fn multi ->
      changeset = Article.changeset(%Article{ id: event.id }, %{
        type_of: event.type_of,
        title: event.title,
        description: event.description,
        cover_image: event.cover_image,
        published_at: event.published_at,
        published_timestamp: event.published_timestamp,
        slug: event.slug,
        path: event.path,
        url: event.url,
        canonical_url: event.canonical_url,
        comments_count: event.comments_count,
        positive_reactions_count: event.positive_reactions_count,
        tag_list: event.tag_list,
        user: event.user,
        organization: event.organization
      })
      Ecto.Multi.insert_or_update(
        multi,
        :article,
        changeset,
        on_conflict: :nothing
      )
    end
  )
end
