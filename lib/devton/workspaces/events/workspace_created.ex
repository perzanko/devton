defmodule Devton.Workspaces.Events.WorkspaceCreated do
  @derive [Jason.Encoder]
  defstruct [:uuid, :name, :token, :enabled?]
end
