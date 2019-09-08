defmodule Devton.Workspaces.Repositories.WorkspaceRepository do

  import Ecto.Query

  alias Devton.Repo
  alias Devton.Workspaces.Projections.Workspace


  def find_all(), do: Repo.all(Workspace)

  def find_one(clause) do
    case clause do
      %{"uuid" => uuid} ->
        Repo.get(Workspace, uuid)
      %{"name" => name} ->
        Repo.get_by(Workspace, name: name)
      _ -> {:error, :invalid_query}
    end
  end
end
