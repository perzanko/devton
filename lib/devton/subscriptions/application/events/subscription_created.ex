defmodule Devton.Subscriptions.Events.SubscriptionCreated do
  @derive [Jason.Encoder]
  defstruct [
    :uuid,
    :cron_tabs,
    :is_active,
    :started_at,
    :workspace,
    :user,
    :tags,
    :sent_articles
  ]
end
