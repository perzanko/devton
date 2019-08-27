defmodule Devton.Workspaces.EventHandlers.WorkspaceCreated do
  use Commanded.Event.Handler, name: "Workspaces.EventHandlers.WorkspaceCreated"

  alias Devton.Workspaces.Events.WorkspaceCreated

  def handle(%WorkspaceCreated{}, _metadata) do
    DevtonSlack.Manager.refresh(500)
    :ok
  end
end
