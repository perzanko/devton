defmodule Devton.Subscriptions do
  @moduledoc false

  import Ecto.Query, only: [from: 2]

  alias Devton.Repo
  alias Devton.Router

  alias Devton.Subscriptions.Commands.{
    CreateSubscription,
    }

  alias Devton.Subscriptions.Projections.Subscription
  alias Devton.Support.Service.CronTab

  def get_subscription(clause) do
    result = case clause do
      %{"id" => uuid} ->
        Repo.get(Subscription, uuid)
      _ -> {:error, :invalid_query}
    end
    case result do
      %Subscription{} = subscription ->
        {:ok, subscription}
      _ ->
        {:error, :not_found}
    end
  end

  def get_subscriptions(%{"workspace_id" => workspace_id, "user_id" => user_id}) do
    Repo.all(
      from s in Subscription,
      select: s,
      where: s.is_active == true and
             fragment("?->>'id'", s.workspace) == ^workspace_id and
             fragment("?->>'id'", s.user) == ^user_id
    )
  end
  def get_subscriptions(), do: Repo.all(Subscription)

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
end
