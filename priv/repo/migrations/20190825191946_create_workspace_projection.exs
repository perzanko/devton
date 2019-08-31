defmodule Devton.Repo.Migrations.CreateWorkspaceProjection do
  use Ecto.Migration

  def change do
    create table(:workspace, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :name, :string
      add :token, :string
      add :bot_token, :string
      add :enabled, :boolean

      timestamps([type: :utc_datetime])
    end
  end

  def down do
    drop table("workspace")
  end
end
