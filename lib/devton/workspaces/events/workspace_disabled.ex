defmodule Devton.Workspaces.Events.WorkspaceDisabled do
  @derive [Jason.Encoder]
  defstruct [:uuid, :name, :token, :identifier, :enabled?]
end
