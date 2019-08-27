defmodule Devton.Workspaces.Events.WorkspaceCreated do
  @derive [Jason.Encoder]
  defstruct [:uuid, :name, :token, :bot_token, :identifier, :enabled?]
end
