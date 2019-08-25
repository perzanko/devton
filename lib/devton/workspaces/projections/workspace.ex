defmodule Devton.Workspaces.Projections.Workspace do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "workspace" do
    field :name, :string
    field :token, :string
    field :enabled, :boolean

    timestamps()
  end
end
