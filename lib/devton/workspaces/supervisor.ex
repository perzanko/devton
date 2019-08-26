defmodule Devton.Workspaces.Supervisor do
  use Supervisor

  alias Devton.Workspaces.Projectors
  alias Devton.Workspaces.ProcessManagers

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(arg) do
    children = [
      # Projectors
      worker(Projectors.WorkspaceCreated, [], id: :workspace_created_projector),
      worker(Projectors.WorkspaceEnabled, [], id: :workspace_enabled_projector),
      worker(Projectors.WorkspaceDisabled, [], id: :workspace_disabled_projector),

      # Process managers
      worker(ProcessManagers.WorkspacesSaga, [], id: :workspaces_saga)
    ]

    supervise(children, strategy: :one_for_one)
  end
end
