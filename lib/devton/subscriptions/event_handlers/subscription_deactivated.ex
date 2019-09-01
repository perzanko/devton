defmodule Devton.Subscriptions.EventHandlers.SubscriptionDeactivated do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SubscriptionDeactivated"

  alias Devton.Subscriptions.Events.SubscriptionDeactivated

  def handle(%SubscriptionDeactivated{} = event, metadata) do
    send_unsubscribed_message(event.workspace["name"], event.user["id"], event.uuid)
    :ok
  end

  defp send_unsubscribed_message(workspace_name, user_id, uuid) do
    spawn(
      fn ->
        DevtonSlack.Rtm.send_message_to_channel(
          workspace_name,
          user_id,
          DevtonSlack.Message.unsubscribed_success(uuid)
        )
      end
    )
  end
  defp send_unsubscribed_message(_, %{}) do
    false
  end
end
