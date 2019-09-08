defmodule Devton.Workspaces.Commands.CreateWorkspace do
  @enforce_keys [:uuid, :name, :token, :bot_token, :identifier, :enabled?]
  defstruct [:uuid, :name, :token, :bot_token, :identifier, :enabled?]
end
