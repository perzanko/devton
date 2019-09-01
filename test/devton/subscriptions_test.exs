defmodule Devton.Subscriptions.SubscriptionsTest do
  use Devton.Test.InMemoryEventStoreCase
  use Devton.ProjectorCase

  alias Devton.Test.Mother
  alias Devton.Subscriptions
  alias Devton.Subscriptions.Projections.Subscription

  @tag :create_subscription
  test "creates subscription with valid command" do
    sub = Mother.Subscription.simple()
    assert {:ok, %Subscription{uuid: uuid}} = Subscriptions.create_subscription(sub)
    assert is_binary(uuid) == true

    :timer.sleep(500)

    {
      :ok,
      %Subscription{cron_tabs: cron_tabs, is_active: is_active, tags: tags, user: user, workspace: workspace}
    } = Subscriptions.get_subscription(%{"uuid" => uuid})
    assert cron_tabs = ["00 10 * * 1"]
    assert is_active = true
    assert tags = String.split(sub["tags"], ",")
  end

  @tag :create_subscription
  test "creates subscription with invalid command (day)" do
    sub = Mother.Subscription.with_invalid_day()
    assert {:error, :invalid_day} = Subscriptions.create_subscription(sub)
  end

  @tag :create_subscription
  test "creates subscription with invalid command (time)" do
    sub = Mother.Subscription.with_invalid_time()
    assert {:error, :invalid_time} = Subscriptions.create_subscription(sub)
  end

  @tag :deactivate_subscription
  test "deactivates subscription" do
    sub = Mother.Subscription.simple()
    assert {:ok, %Subscription{ uuid: uuid }} = Subscriptions.create_subscription(sub)

    :timer.sleep(500)

    assert {:ok, true} = Subscriptions.deactivate_subscription(%{ "uuid" => uuid })
  end
end
