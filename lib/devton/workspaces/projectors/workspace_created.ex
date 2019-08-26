defmodule Devton.Workspaces.Projectors.WorkspaceCreated do
  use Commanded.Projections.Ecto, name: "Workspaces.Projectors.WorkspaceCreated"

  alias Devton.Workspaces.Events.WorkspaceCreated
  alias Devton.Workspaces.Projections.Workspace

  project(
    %WorkspaceCreated{} = event,
    _metadata,
    fn multi ->
      Ecto.Multi.insert(
        multi,
        :workspace,
        %Workspace{
          uuid: event.uuid,
          name: event.name,
          identifier: event.identifier,
          enabled: event.enabled?,
          token: event.token
        }
      )
    end
  )
end
