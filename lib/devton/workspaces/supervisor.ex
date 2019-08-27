defmodule Devton.Workspaces.Supervisor do
  use Supervisor

  alias Devton.Workspaces.Projectors
  alias Devton.Workspaces.ProcessManagers
  alias Devton.Workspaces.EventHandlers

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
      worker(ProcessManagers.WorkspacesSaga, [], id: :workspaces_saga),

      # Event handlers
      worker(EventHandlers.WorkspaceCreated, [], id: :workspace_created_handler),
      worker(EventHandlers.WorkspaceEnabled, [], id: :workspace_enabled_handler),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
