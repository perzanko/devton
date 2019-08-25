defmodule Devton.Router do
  use Commanded.Commands.Router

  alias Devton.Workspaces.Aggregates.Workspace

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    }


  middleware(Devton.Support.Middleware.ValidateCommand)

  dispatch(
    [
      CreateWorkspace,
    ],
    to: Workspace,
    identity: :uuid
  )
end
