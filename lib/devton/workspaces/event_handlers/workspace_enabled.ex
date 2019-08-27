defmodule Devton.Workspaces.EventHandlers.WorkspaceEnabled do
  use Commanded.Event.Handler, name: "Workspaces.EventHandlers.WorkspaceEnabled"

  alias Devton.Workspaces.Events.WorkspaceEnabled

  def handle(%WorkspaceEnabled{} = event, metadata) do
    refresh_bots()
    send_welcome_message(event.name, metadata)
    :ok
  end

  defp refresh_bots() do
    spawn(fn ->
      :timer.sleep(1000);
      DevtonSlack.Manager.refresh
    end)
  end

  defp send_welcome_message(workspace_name, %{"user_id" => user_id}) do
    spawn(fn ->
      :timer.sleep(2000);
      DevtonSlack.Rtm.send_message_to_channel(
        workspace_name,
        user_id,
        DevtonSlack.Message.welcome(user_id) <> DevtonSlack.Message.help
      )
    end)
  end
  defp send_welcome_message(_, %{}) do
    false
  end
end
