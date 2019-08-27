defmodule Devton.Workspaces.Events.WorkspaceDisabled do
  @derive [Jason.Encoder]
  defstruct [:uuid, :name, :token, :bot_token, :identifier, :enabled?]
end
