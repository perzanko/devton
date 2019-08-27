defmodule Devton.Workspaces.Commands.EnableWorkspace do
  @enforce_keys [:uuid, :token, :bot_token]
  defstruct [:uuid, :token, :bot_token]

  def valid?(command) do
    Map.from_struct(command)
    |> Skooma.valid?(schema())
  end

  defp schema do
    %{
      uuid: :string,
      token: :string,
      bot_token: :string
    }
  end
end
