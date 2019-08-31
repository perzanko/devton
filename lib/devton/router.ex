defmodule Devton.Router do
  use Commanded.Commands.Router

  alias Devton.Workspaces.Aggregates.Workspace
  alias Devton.Library.Aggregates.Tag

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    EnableWorkspace,
    DisableWorkspace,
    }

  alias Devton.Library.Commands.{
    CreateTag,
    }

  dispatch(
    [
      CreateWorkspace,
      EnableWorkspace,
      DisableWorkspace,
    ],
    to: Workspace,
    identity: :uuid
  )

  dispatch(
    [
      CreateTag,
    ],
    to: Tag,
    identity: :id
  )
end
