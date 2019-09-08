defmodule Devton.Subscriptions.SubscriptionsTest do
  use Devton.Test.InMemoryEventStoreCase
  use Devton.ProjectorCase

  alias Devton.Test.Mother
  alias Devton.Subscriptions
  alias Devton.Subscriptions.Projections.Subscription
  alias Devton.Library.Projections.Article

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

  @tag :get_subscriptions_count
  test "gets subscriptions count" do
    sub = Mother.Subscription.simple()
    Subscriptions.create_subscription(sub)
    Subscriptions.create_subscription(sub)

    :timer.sleep(500)

    assert 2 == Subscriptions.get_subscriptions_count()
  end

  @tag :scoring_articles
  test "reorder articles based on popularity of tags and subscription tags" do
    tags = ["javascript", "ruby", "node"]
    art1 = %Article{ id: 1, tag_list: ["javascript", "ruby"], positive_reactions_count: 10 }
    art2 = %Article{ id: 2, tag_list: ["php", "ruby"], positive_reactions_count: 16  }
    art3 = %Article{ id: 3, tag_list: ["node", "ruby", "flutter"], positive_reactions_count: 9  }
    art4 = %Article{ id: 4, tag_list: ["php"], positive_reactions_count: 10  }
    art5 = %Article{ id: 5, tag_list: ["node", "javascript"], positive_reactions_count: 15  }
    art6 = %Article{ id: 6, tag_list: ["node", "javascript", "ruby"], positive_reactions_count: 12  }
    popularity_of_tags = %{ "javascript" => 150, "node" => 100, "ruby" => 50 }

    result = Devton.Subscriptions.Aggregates.Subscription.reorder_articles_basing_on_scoring(
      [art1, art2, art3, art4, art5, art6],
      tags,
      popularity_of_tags
    )

    assert [art6, art2, art5, art3, art1, art4] = result
  end
end
