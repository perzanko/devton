defmodule Devton.Subscriptions.EventHandlers.SubscriptionCreated do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SubscriptionCreated"

  alias Devton.Subscriptions.Events.SubscriptionCreated

  def handle(%SubscriptionCreated{} = event, metadata) do
    IO.inspect(event)
    send_subscribed_message(event.workspace["name"], event.user["id"], event.tags)
    IO.inspect(event);
    :ok
  end

  defp send_subscribed_message(workspace_name, user_id, tags) do
    spawn(
      fn ->
        DevtonSlack.Rtm.send_message_to_channel(
          workspace_name,
          user_id,
          DevtonSlack.Message.subscribed_success(tags)
        )
      end
    )
  end
  defp send_subscribed_message(_, %{}) do
    false
  end
end
