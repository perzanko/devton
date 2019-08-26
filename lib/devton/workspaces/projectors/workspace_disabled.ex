defmodule Devton.Workspaces.Projectors.WorkspaceDisabled do
  use Commanded.Projections.Ecto, name: "Workspaces.Projectors.WorkspaceDisabled"

  alias Devton.Workspaces.Events.WorkspaceDisabled
  alias Devton.Workspaces.Projections.Workspace
  alias Devton.Workspaces
  alias Ecto.{Changeset, Multi}

  project(
    %WorkspaceDisabled{} = event,
    _metadata,
    fn multi ->
      with {:ok, %Workspace{} = workspace} <- Workspaces.get_workspace(event.uuid) do
        Multi.update(
          multi,
          :workspace,
          Changeset.change(
            workspace,
            enabled: event.enabled?
          )
        )
      else
        _ -> multi
      end
    end
  )
end
