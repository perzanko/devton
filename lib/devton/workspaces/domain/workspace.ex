defmodule Devton.Workspaces.Aggregates.Workspace do
  defstruct uuid: nil,
            name: nil,
            identifier: nil,
            bot_token: nil,
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
          identifier: identifier,
          token: token,
          bot_token: bot_token,
          enabled?: enabled?,
        }
      ) do
    %WorkspaceCreated{
      uuid: uuid,
      name: name,
      identifier: identifier,
      token: token,
      bot_token: bot_token,
      enabled?: enabled?,
    }
  end

  def execute(
        %Workspace{uuid: uuid} = workspace,
        %EnableWorkspace{uuid: uuid, token: token, bot_token: bot_token}
      ) do
    %WorkspaceEnabled{
      uuid: uuid,
      enabled?: true,
      identifier: workspace.identifier,
      token: token,
      bot_token: bot_token,
      name: workspace.name,
    }
  end

  def execute(
        %Workspace{uuid: uuid} = workspace,
        %DisableWorkspace{uuid: uuid}
      ) do
    %WorkspaceDisabled{
      uuid: uuid,
      enabled?: false,
      bot_token: workspace.bot_token,
      token: workspace.token,
      identifier: workspace.identifier,
      name: workspace.name,
    }
  end

  #  state mutators

  def apply(
        %Workspace{uuid: uuid} = workspace,
        %WorkspaceEnabled{
          uuid: uuid,
          enabled?: enabled?,
          token: token,
          bot_token: bot_token,
        }
      ) do
    %Workspace{workspace | enabled?: enabled?, token: token, bot_token: bot_token}
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
          bot_token: bot_token,
          identifier: identifier,
          enabled?: enabled?,
        }
      ) do
    %Workspace{
      workspace
    |
      uuid: uuid,
      name: name,
      token: token,
      bot_token: bot_token,
      identifier: identifier,
      enabled?: enabled?,
    }
  end
end
