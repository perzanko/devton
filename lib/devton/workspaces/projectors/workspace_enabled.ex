defmodule Devton.Workspaces.Projectors.WorkspaceEnabled do
  use Commanded.Projections.Ecto, name: "Workspaces.Projectors.WorkspaceEnabled"

  alias Devton.Workspaces.Events.WorkspaceEnabled
  alias Devton.Workspaces.Projections.Workspace
  alias Devton.Workspaces
  alias Ecto.{Changeset, Multi}

  project(
    %WorkspaceEnabled{} = event,
    _metadata,
    fn multi ->
      with {:ok, %Workspace{} = workspace} <- Workspaces.get_workspace(%{"uuid" => event.uuid}) do
        Multi.update(
          multi,
          :workspace,
          Changeset.change(
            workspace,
            enabled: event.enabled?,
            token: event.token,
            bot_token: event.bot_token
          )
        )
      else
        _ -> multi
      end
    end
  )
end
