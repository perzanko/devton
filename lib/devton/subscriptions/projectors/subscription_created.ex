defmodule Devton.Subscriptions.Projectors.SubscriptionCreated do
  use Commanded.Projections.Ecto, name: "Subscriptions.Projectors.SubscriptionCreated"

  alias Devton.Repo
  alias Devton.Subscriptions.Events.SubscriptionCreated
  alias Devton.Subscriptions.Projections.Subscription

  project(
    %SubscriptionCreated{} = event,
    _metadata,
    fn multi ->
      changeset = Subscription.changeset(
        %Subscription{uuid: event.uuid},
        %{
          cron_tabs: event.cron_tabs,
          is_active: event.is_active,
          started_at: event.started_at,
          workspace: event.workspace,
          user: event.user,
          tags: case is_list(event.tags) do
            true -> event.tags
            false -> [event.tags || ""]
          end,
          sent_articles: event.sent_articles,
        }
      )
      Ecto.Multi.insert(
        multi,
        :subscription,
        changeset
      )
    end
  )
end
