defmodule Devton.Workspaces.Commands.DisableWorkspace do
  @enforce_keys [:uuid]
  defstruct [:uuid]

  def valid?(command) do
    Map.from_struct(command)
    |> Skooma.valid?(schema())
  end

  defp schema do
    %{uuid: :string}
  end
end
