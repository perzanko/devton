defmodule Devton.Repo.Migrations.AddSubscription do
  use Ecto.Migration

  def change do
    create table(:subscription, primary_key: false) do
      add :uuid, :uuid, primary_key: true
      add :cron_tabs, {:array, :string}
      add :is_active, :boolean
      add :started_at, :utc_datetime
      add :workspace, :map
      add :user, :map
      add :tags, {:array, :string}
      add :sent_articles, {:array, :map}

      timestamps([type: :utc_datetime])
    end
  end

  def down do
    drop table("subscription")
  end
end
