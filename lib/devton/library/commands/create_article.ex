defmodule Devton.Library.Commands.CreateArticle do
  @enforce_keys [:id]
  defstruct [
    :id,
    :type_of,
    :title,
    :description,
    :cover_image,
    :published_at,
    :published_timestamp,
    :slug,
    :path,
    :url,
    :canonical_url,
    :comments_count,
    :positive_reactions_count,
    :tag_list,
    :user,
    :organization
  ]
end
