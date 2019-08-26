defmodule Devton.Repo.Migrations.AddWorkspaceIdToWorkspace do
  use Ecto.Migration

  def change do
    alter table(:workspace) do
      add :identifier, :string
    end
  end

  def down do
    alter table(:workspace) do
      remove :identifier
    end
  end
end
