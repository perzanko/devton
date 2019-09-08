defmodule Devton.Subscriptions.Commands.CreateSubscription do
  @enforce_keys [:uuid, :cron_tabs, :tags, :workspace_id, :workspace_name, :user_id, :user_name, :user_tz]
  defstruct [:uuid, :cron_tabs, :tags, :workspace_id, :workspace_name, :user_id, :user_name, :user_tz]
end
