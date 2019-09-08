defmodule Devton.Library.Projections.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "article" do
    field :type_of, :string
    field :title, :string
    field :description, :string
    field :cover_image, :string
    field :published_at, :utc_datetime
    field :published_timestamp, :utc_datetime
    field :slug, :string
    field :path, :string
    field :url, :string
    field :canonical_url, :string
    field :comments_count, :integer
    field :positive_reactions_count, :integer
    field :tag_list, {:array, :string}
    field :user, :map
    field :organization, :map

    timestamps([type: :utc_datetime])
  end

  def changeset(article, params \\ %{}) do
    article
    |> cast(
         params,
         [
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
       )
  end
end
