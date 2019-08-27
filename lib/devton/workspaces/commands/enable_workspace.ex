defmodule Devton.Workspaces.Commands.EnableWorkspace do
  @enforce_keys [:uuid, :token]
  defstruct [:uuid, :token]

  def valid?(command) do
    Map.from_struct(command)
    |> Skooma.valid?(schema())
  end

  defp schema do
    %{uuid: :string, token: :string}
  end
end
