defmodule Devton.Subscriptions.EventHandlers.SubscriptionCreated do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SubscriptionCreated"

  alias Devton.Subscriptions.Events.SubscriptionCreated
  alias DevtonSlack.{Rtm,Message}
  alias DevtonScheduler.SchedulerManager

  def handle(%SubscriptionCreated{} = event, metadata) do
    send_subscribed_message(event.workspace["name"], event.user["id"], event.tags)
    refresh_subscription_jobs()
    :ok
  end

  defp send_subscribed_message(workspace_name, user_id, tags) do
    Task.async(
      fn ->
        Rtm.send_message_to_channel(
          workspace_name,
          user_id,
          Message.subscribed_success(tags)
        )
      end
    )
  end
  defp send_subscribed_message(_, %{}) do
    false
  end

  defp refresh_subscription_jobs, do: SchedulerManager.refresh_subscriptions(1000)
end
