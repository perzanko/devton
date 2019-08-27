defmodule Devton.Workspaces.Commands.CreateWorkspace do
  @enforce_keys [:uuid, :name, :token, :bot_token, :identifier, :enabled?]
  defstruct [:uuid, :name, :token, :bot_token, :identifier, :enabled?]

  def valid?(command) do
    Skooma.valid?(Map.from_struct(command), schema())
  end

  defp schema do
    %{
      uuid: :string,
      name: :string,
      token: :string,
      bot_token: :string,
      identifier: :string
    }
  end
end
