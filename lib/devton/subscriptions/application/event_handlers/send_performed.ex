defmodule Devton.Subscriptions.EventHandlers.SendPerformed do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SendPerformed"

  alias Devton.Subscriptions.Events.SendPerformed
  alias Devton.{Subscriptions, Library}
  alias DevtonSlack.{Rtm, Message}

  def handle(%SendPerformed{} = event, metadata) do
    if event.article_id != nil do
      send_article_message(event)
    end
    :ok
  end

  defp send_article_message(%SendPerformed{} = event) do
    Task.async(
      fn ->
        :timer.sleep(500)
        {:ok, subscription} = Subscriptions.get_subscription(%{"uuid" => event.uuid})
        {:ok, article} = Library.get_article(%{"id" => event.article_id})
        Rtm.send_message_to_channel(
          subscription.workspace["name"],
          subscription.user["id"],
          Message.article(subscription.user["id"], article)
        )
      end
    )
  end
  defp send_article_message(_, %{}) do
    false
  end
end
