defmodule Devton.Subscriptions.Projections.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "subscription" do
    field :cron_tabs, {:array, :string}
    field :is_active, :boolean
    field :started_at, :utc_datetime
    field :workspace, :map
    field :user, :map
    field :tags, {:array, :string}
    field :sent_articles, {:array, :map}

    timestamps([type: :utc_datetime])
  end

  def changeset(subscription, params \\ %{}) do
    subscription
    |> cast(
         params,
         [
           :cron_tabs,
           :is_active,
           :started_at,
           :workspace,
           :user,
           :tags,
           :sent_articles
         ]
       )
  end
end
