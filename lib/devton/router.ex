defmodule Devton.Router do
  use Commanded.Commands.Router

  alias Devton.Workspaces.Aggregates.Workspace

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    }

  dispatch(
    [
      CreateWorkspace,
    ],
    to: Workspace,
    identity: :uuid
  )
end
