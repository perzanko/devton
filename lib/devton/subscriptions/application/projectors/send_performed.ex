defmodule Devton.Subscriptions.Projectors.SendPerformed do
  use Commanded.Projections.Ecto, name: "Subscriptions.Projectors.SendPerformed"

  alias Devton.Repo
  alias Devton.Subscriptions.Events.SendPerformed
  alias Devton.Subscriptions.Projections.Subscription

  project(
    %SendPerformed{} = event,
    _metadata,
    fn multi ->
      if event.article_id != nil do
        subscription = Devton.Repo.get!(Subscription, event.uuid)
        Ecto.Multi.update(
          multi,
          :subscription,
          Ecto.Changeset.change(subscription, sent_articles: [ %{ id: event.article_id, sent_at: event.sent_at} | subscription.sent_articles ])
        )
      else
        multi
      end
    end
  )
end
