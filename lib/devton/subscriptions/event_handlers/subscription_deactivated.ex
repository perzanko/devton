defmodule Devton.Subscriptions.EventHandlers.SubscriptionDeactivated do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SubscriptionDeactivated"

  alias Devton.Subscriptions.Events.SubscriptionDeactivated
  alias DevtonSlack.{Message, Rtm}

  def handle(%SubscriptionDeactivated{} = event, metadata) do
    send_unsubscribed_message(event.workspace["name"], event.user["id"], event.uuid)
    remove_scheduled_subscription(event.uuid)
    :ok
  end

  defp send_unsubscribed_message(workspace_name, user_id, uuid) do
    spawn(
      fn ->
        Rtm.send_message_to_channel(
          workspace_name,
          user_id,
          Message.unsubscribed_success(uuid)
        )
      end
    )
  end
  defp send_unsubscribed_message(_, %{}) do
    false
  end

  defp remove_scheduled_subscription(uuid),
       do: Devton.SchedulerManager.remove_subscription(%{ "uuid" => uuid }, 1000)
end
