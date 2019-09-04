defmodule Devton.Repo.Migrations.AddTopTagProjection do
  use Ecto.Migration

  def change do
    create table(:top_tag) do
      add :tag_name, :string

      timestamps([type: :utc_datetime])
    end
  end

  def down do
    drop table("top_tag")
  end
end
