defmodule Devton.Subscriptions.Repositories.SubscriptionRepository do

  import Ecto.Query

  alias Devton.Repo
  alias Devton.Subscriptions.Projections.Subscription

  def find_all(%{"workspace_id" => workspace_id, "user_id" => user_id}) do
    Repo.all(
      from s in Subscription,
      select: s,
      where: s.is_active == true and
             fragment("?->>'id'", s.workspace) == ^workspace_id and
             fragment("?->>'id'", s.user) == ^user_id
    )
  end

  def find_all(%{"active" => true}) do
    Repo.all(
      from s in Subscription,
      select: s,
      where: s.is_active == true
    )
  end

  def find_all(), do: Repo.all(Subscription)

  def get_count() do
    Repo.aggregate(from(p in Subscription), :count, :uuid)
  end

  def find_one(clause) do
    case clause do
      %{"uuid" => uuid} ->
        Repo.get(Subscription, uuid)
      _ -> {:error, :invalid_query}
    end
  end

  def get_sent_articles_to_user(user_id) do
    query = from s in Subscription,
                 select: [s.sent_articles],
                 where: fragment("?->>'id'", s.user) == ^user_id
    Repo.all(query)
    |> Enum.map(fn [x | _] -> x end)
    |> List.flatten
  end
end
