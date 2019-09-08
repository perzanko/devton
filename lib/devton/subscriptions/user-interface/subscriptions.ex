defmodule Devton.Subscriptions do
  @moduledoc false

  alias Devton.Router
  alias Devton.Library

  alias Devton.Subscriptions.Repositories.SubscriptionRepository

  alias Devton.Subscriptions.Commands.{
    CreateSubscription,
    DeactivateSubscription,
    PerformSend,
    }

  alias Devton.Subscriptions.Projections.Subscription
  alias Devton.Support.Service.CronTab

  #  Query

  def get_subscription(clause) do
    case SubscriptionRepository.find_one(clause) do
      %Subscription{} = subscription ->
        {:ok, subscription}
      _ ->
        {:error, :not_found}
    end
  end

  def get_subscriptions(opts) do
    SubscriptionRepository.find_all(opts)
  end

  def get_subscriptions() do
    SubscriptionRepository.find_all()
  end

  def get_subscriptions_count() do
    SubscriptionRepository.get_count()
  end

  #  Command

  def create_subscription(
        %{
          "tags" => tags,
          "day" => day,
          "time" => time,
          "workspace_id" => workspace_id,
          "workspace_name" => workspace_name,
          "user_id" => user_id,
          "user_name" => user_name,
          "user_tz" => user_tz,
        },
        metadata \\ %{}
      ) do
    case CronTab.convert_to_cron_tabs(day, time) do
      {:ok, cron_tabs} ->
        uuid = UUID.uuid4()
        tag_list = String.split(tags, ",")
        result =
          %CreateSubscription{
            uuid: uuid,
            tags: tag_list,
            cron_tabs: cron_tabs,
            workspace_name: workspace_name,
            workspace_id: workspace_id,
            user_id: user_id,
            user_name: user_name,
            user_tz: user_tz,
          }
          |> Router.dispatch(metadata: metadata)

        case result do
          :ok ->
            {
              :ok,
              %Subscription{uuid: uuid}
            }
          reply -> reply
        end
      reply -> reply
    end
  end

  def perform_send(%{"uuid" => uuid, "random" => random}, metadata \\ %{}) do
    subscription = SubscriptionRepository.find_one(%{"uuid" => uuid})
    sent_articles = SubscriptionRepository.get_sent_articles_to_user(subscription.user["id"])
    popularity_of_tags = Library.get_tag_list_tops(subscription.tags)
    suggested_articles = case random == true do
      true -> Library.get_suggested_articles()
      false -> Library.get_suggested_articles(subscription.tags)
    end
    result =
      %PerformSend{
        uuid: uuid,
        sent_articles: sent_articles,
        suggested_articles: suggested_articles,
        random: random == true,
        popularity_of_tags: popularity_of_tags,
      }
      |> Router.dispatch(metadata: metadata)
    case result do
      :ok ->
        {
          :ok,
          true
        }
      reply -> reply
    end
  end

  def deactivate_subscription(%{"uuid" => uuid}, metadata \\ %{}) do
    result =
      %DeactivateSubscription{uuid: uuid}
      |> Router.dispatch(metadata: metadata)
    case result do
      :ok ->
        {
          :ok,
          true
        }
      reply -> reply
    end
  end
end
