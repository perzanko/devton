defmodule Devton.Workspaces.EventHandlers.WorkspaceEnabled do
  use Commanded.Event.Handler, name: "Workspaces.EventHandlers.WorkspaceEnabled"

  alias Devton.Workspaces.Events.WorkspaceEnabled

  def handle(%WorkspaceEnabled{}, _metadata) do
    DevtonSlack.Manager.refresh(500)
    :ok
  end
end
