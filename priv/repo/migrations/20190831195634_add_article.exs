defmodule Devton.Repo.Migrations.AddArticle do
  use Ecto.Migration

  def change do
    create table(:article) do
      add :type_of, :string
      add :title, :string
      add :description, :text
      add :cover_image, :text
      add :published_at, :utc_datetime
      add :published_timestamp, :utc_datetime
      add :slug, :string
      add :path, :string
      add :url, :string
      add :canonical_url, :string
      add :comments_count, :integer
      add :positive_reactions_count, :integer
      add :tag_list, {:array, :string}
      add :user, :map
      add :organization, :map

      timestamps([type: :utc_datetime])
    end
  end

  def down do
    drop table("article")
  end

end
