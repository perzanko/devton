defmodule Devton.Workspaces.Aggregates.Workspace do
  defstruct uuid: nil,
            name: nil,
            token: nil,
            enabled?: true

  alias __MODULE__

  alias Devton.Workspaces.Commands.{
    CreateWorkspace,
    EnableWorkspace,
    DisableWorkspace,
    }
  alias Devton.Workspaces.Events.{
    WorkspaceCreated,
    WorkspaceEnabled,
    WorkspaceDisabled,
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

  def execute(
        %Workspace{uuid: uuid, enabled?: enabled, token: token, name: name},
        %EnableWorkspace{uuid: uuid}
      ) do
    %WorkspaceEnabled{
      uuid: uuid,
      enabled?: true,
      token: token,
      name: name,
    }
  end

  def execute(
        %Workspace{uuid: uuid, enabled?: enabled, token: token, name: name},
        %DisableWorkspace{uuid: uuid}
      ) do
    %WorkspaceDisabled{
      uuid: uuid,
      enabled?: false,
      token: token,
      name: name,
    }
  end

  #  state mutators

  def apply(
        %Workspace{uuid: uuid} = workspace,
        %WorkspaceEnabled{
          uuid: uuid,
          enabled?: enabled?,
        }
      ) do
    %Workspace{workspace | enabled?: enabled?}
  end

  def apply(
        %Workspace{uuid: uuid} = workspace,
        %WorkspaceDisabled{
          uuid: uuid,
          enabled?: enabled?,
        }
      ) do
    %Workspace{workspace | enabled?: enabled?}
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
