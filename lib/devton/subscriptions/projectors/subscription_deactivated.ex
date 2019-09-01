defmodule Devton.Subscriptions.Projectors.SubscriptionDeactivated do
  use Commanded.Projections.Ecto, name: "Subscriptions.Projectors.SubscriptionDeactivated"

  alias Devton.Repo
  alias Devton.Subscriptions.Events.SubscriptionDeactivated
  alias Devton.Subscriptions.Projections.Subscription

  project(
    %SubscriptionDeactivated{} = event,
    _metadata,
    fn multi ->
      subscription = Devton.Repo.get!(Subscription, event.uuid)
      Ecto.Multi.insert(
        multi,
        :subscription,
        Ecto.Changeset.change(subscription, is_active: event.is_active)
      )
    end
  )
end
