defmodule Devton.Workspaces.Commands.CreateWorkspace do
  @enforce_keys [:uuid, :name, :token, :enabled?]
  defstruct [:uuid, :name, :token, :enabled?]
end
