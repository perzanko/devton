defmodule Devton.Repo.Migrations.AddLibraryTag do
  use Ecto.Migration

  def change do
    create table(:tag) do
      add :name, :string
      add :bg_color_hex, :string
      add :text_color_hex, :string

      timestamps([type: :utc_datetime])
    end
  end

  def down do
    drop table("tag")
  end
end
