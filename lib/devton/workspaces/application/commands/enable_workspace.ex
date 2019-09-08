defmodule Devton.Workspaces.Commands.EnableWorkspace do
  @enforce_keys [:uuid, :token, :bot_token]
  defstruct [:uuid, :token, :bot_token]
end
