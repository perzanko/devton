defmodule Devton.Workspaces.ProcessManagers.WorkspacesSaga do
  use Commanded.ProcessManagers.ProcessManager,
      name: "Workspaces.ProcessManagers.WorkspacesSaga",
      router: Devton.Router

  @derive Jason.Encoder
  defstruct [
  ]

  alias __MODULE__

  alias Devton.Workspaces.Events.{
    WorkspaceCreated,
    WorkspaceEnabled,
    WorkspaceDisabled,
    }

  alias Devton.Workspaces.Commands.{}

  def interested?(%WorkspaceCreated{}), do: false
  def interested?(%WorkspaceEnabled{}), do: false
  def interested?(%WorkspaceDisabled{}), do: false
  def interested?(_event), do: false
end
