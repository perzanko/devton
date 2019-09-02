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

  alias Devton.Subscriptions.Commands.{CreateSubscription, DeactivateSubscription, PerformSend}
  alias Devton.Subscriptions.Events.{SubscriptionCreated, SubscriptionDeactivated, SendPerformed}

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

  def execute(
        %Subscription{uuid: uuid} = subscription,
        %DeactivateSubscription{uuid: uuid}
      ) do
    %SubscriptionDeactivated{
      uuid: uuid,
      is_active: false,
      cron_tabs: subscription.cron_tabs,
      started_at: subscription.started_at,
      workspace: subscription.workspace,
      user: subscription.user,
      tags: subscription.tags,
      sent_articles: subscription.sent_articles
    }
  end

  def execute(
        %Subscription{uuid: uuid, is_active: false} = subscription,
        %PerformSend{uuid: uuid} = perform_send
      ) do
    {:error, :subscription_is_not_active}
  end

  def execute(
        %Subscription{uuid: uuid, is_active: true} = subscription,
        %PerformSend{
          uuid: uuid,
          sent_articles: sent_articles_to_user,
          suggested_tags_articles: suggested_tags_articles,
          suggested_other_articles: suggested_other_articles
        }
      ) do
    {:ok, sent_at} = DateTime.now("Etc/UTC")
    sent_articles_ids = sent_articles_to_user |> Enum.map(fn article -> article["id"] end)
    suggested_tags_articles ++ suggested_other_articles
    |> List.foldl(
         %SendPerformed{uuid: uuid, article_id: nil, sent_at: sent_at},
         fn article_to_send, event ->
           case event.article_id == nil do
             false -> event
             true ->
               if Enum.member?(sent_articles_ids, article_to_send.id) do
                 event
               else
                 %SendPerformed{event | article_id: article_to_send.id }
               end
           end
         end
       )
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

  def apply(
        %Subscription{uuid: uuid} = subscription,
        %SubscriptionDeactivated{uuid: uuid} = subscription_deactivated
      ) do
    %Subscription{
      subscription
    |
      is_active: false,
    }
  end

  def apply(
        %Subscription{uuid: uuid, is_active: true} = subscription,
        %SendPerformed{uuid: uuid, article_id: nil, sent_at: nil} = send_performed
      ) do
    subscription
  end
  def apply(
        %Subscription{uuid: uuid, is_active: true} = subscription,
        %SendPerformed{uuid: uuid, article_id: article_id, sent_at: sent_at} = send_performed
      ) do
    %Subscription{
      subscription
    |
      sent_articles: [%{id: article_id, sent_at: sent_at} | subscription.sent_articles],
    }
  end
end
