defmodule Devton.Subscriptions.Supervisor do
  use Supervisor

  alias Devton.Subscriptions.{Projectors, ProcessManagers, EventHandlers}

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(arg) do
    children = [
      # Event handlers
      worker(EventHandlers.SubscriptionCreated, [], id: :subscription_created_handler),
      # Projectors
      worker(Projectors.SubscriptionCreated, [], id: :subscription_created_projector),

      # Process managers
      worker(ProcessManagers.SubscriptionsSaga, [], id: :subscriptions_saga)
    ]

    supervise(children, strategy: :one_for_one)
  end
end