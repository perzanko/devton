defmodule Devton.Subscriptions.Aggregates.Subscription do
  defstruct uuid: nil,
            is_active: nil,
            started_at: nil,
            cron_tabs: [],
            workspace: %{},
            user: %{},
            tags: [],
            sent_articles: []

  alias __MODULE__

  alias Devton.Subscriptions.Commands.{CreateSubscription}
  alias Devton.Subscriptions.Events.{SubscriptionCreated}

  def execute(
        %Subscription{uuid: nil},
        %CreateSubscription{} = create_subscription
      ) do
    {:ok, started_at} = DateTime.now("Etc/UTC")
    %SubscriptionCreated{
      uuid: create_subscription.uuid,
      cron_tabs: create_subscription.cron_tabs,
      is_active: true,
      started_at: started_at,
      workspace: %{
        id: create_subscription.workspace_id,
        name: create_subscription.workspace_name,
      },
      user: %{
        id: create_subscription.user_id,
        name: create_subscription.user_name,
        timezone: create_subscription.user_tz,
      },
      tags: create_subscription.tags,
      sent_articles: []
    }
  end

  def apply(
        %Subscription{uuid: nil} = subscription,
        %SubscriptionCreated{} = subscription_created
      ) do
    %Subscription{
      subscription
    |
      uuid: subscription_created.uuid,
      cron_tabs: subscription_created.cron_tabs,
      is_active: subscription_created.is_active,
      started_at: subscription_created.started_at,
      workspace: subscription_created.workspace,
      user: subscription_created.user,
      tags: subscription_created.tags,
      sent_articles: subscription_created.sent_articles
    }
  end
end
