defmodule Devton.Subscriptions.EventHandlers.SendPerformed do
  use Commanded.Event.Handler, name: "Subscriptions.EventHandlers.SendPerformed"

  alias Devton.Subscriptions.Events.SendPerformed
  alias Devton.{Subscriptions, Library}
  alias DevtonSlack.{Rtm, Message}

  def handle(%SendPerformed{} = event, metadata) do
    case event.article_id != nil do
      true -> send_article_message(event)
      false -> send_no_article_message(event)
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
          case event.random == true do
            true -> Message.article(subscription, article, true)
            false -> Message.article(subscription, article, false)
          end
        )
      end
    )
  end
  defp send_article_message(_, %{}) do
    false
  end

  defp send_no_article_message(%SendPerformed{} = event) do
    Task.async(
      fn ->
        :timer.sleep(500)
        {:ok, subscription} = Subscriptions.get_subscription(%{"uuid" => event.uuid})
        Rtm.send_message_to_channel(
          subscription.workspace["name"],
          subscription.user["id"],
          Message.no_article(subscription)
        )
      end
    )
  end
  defp send_no_article_message(_, %{}) do
    false
  end
end
