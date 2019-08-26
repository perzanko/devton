defmodule Devton.Router do
  use Commanded.Commands.Router

  alias Devton.Workspaces.Aggregates.Workspace

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    EnableWorkspace,
    DisableWorkspace,
    }


  middleware(Devton.Support.Middleware.ValidateCommand)

  dispatch(
    [
      CreateWorkspace,
      EnableWorkspace,
      DisableWorkspace,
    ],
    to: Workspace,
    identity: :uuid
  )
end
