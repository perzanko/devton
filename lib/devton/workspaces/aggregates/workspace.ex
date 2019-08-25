defmodule Devton.Workspaces.Aggregates.Workspace do
  defstruct uuid: nil,
            name: nil,
            token: nil,
            enabled?: true

  alias __MODULE__

  alias Devton.Workspaces.Commands.{
    CreateWorkspace
    }
  alias Devton.Workspaces.Events.{
    WorkspaceCreated
    }

  def execute(
        %Workspace{uuid: nil},
        %CreateWorkspace{
          uuid: uuid,
          name: name,
          token: token,
          enabled?: enabled?,
        }
      ) do
    %WorkspaceCreated{
      uuid: uuid,
      name: name,
      token: token,
      enabled?: enabled?,
    }
  end

  def apply(
        %Workspace{uuid: nil} = workspace,
        %WorkspaceCreated{
          uuid: uuid,
          name: name,
          token: token,
          enabled?: enabled?,
        }
      ) do
    %Workspace{
      workspace
    |
      uuid: uuid,
      name: name,
      token: token,
      enabled?: enabled?,
    }
  end
end
