defmodule Devton.Workspaces.Events.WorkspaceEnabled do
  @derive [Jason.Encoder]
  defstruct [:uuid, :name, :token, :identifier, :enabled?]
end
