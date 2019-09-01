defmodule Devton.Subscriptions.EventHandlers.SubscriptionCreated do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SubscriptionCreated"

  alias Devton.Subscriptions.Events.SubscriptionCreated

  def handle(%SubscriptionCreated{} = event, metadata) do
#    send_welcome_message(event.name, metadata)
    :ok
  end

#  defp send_welcome_message(workspace_name, %{"user_id" => user_id}) do
#    spawn(
#      fn ->
#        :timer.sleep(2000);
#        DevtonSlack.Rtm.send_message_to_channel(
#          workspace_name,
#          user_id,
#          DevtonSlack.Message.welcome(user_id) <> DevtonSlack.Message.help
#        )
#      end
#    )
#  end
#  defp send_welcome_message(_, %{}) do
#    false
#  end
end
