defmodule Devton.Workspaces.EventHandlers.WorkspaceCreated do
  use Commanded.Event.Handler, name: "Workspaces.EventHandlers.WorkspaceCreated"

  alias Devton.Workspaces.Events.WorkspaceCreated

  def handle(%WorkspaceCreated{name: workspace_name}, metadata) do
    refresh_bots()
    send_welcome_message(workspace_name, metadata)
    :ok
  end

  defp refresh_bots() do
    DevtonSlack.Manager.refresh(500)
  end

  defp send_welcome_message(workspace_name, %{"user_id" => user_id}) do
    DevtonSlack.Rtm.send_message_to_channel(
      workspace_name,
      user_id,
      DevtonSlack.Message.welcome(user_id) <> DevtonSlack.Message.help
    )
  end
  defp send_welcome_message(_, %{}) do
    false
  end
end
