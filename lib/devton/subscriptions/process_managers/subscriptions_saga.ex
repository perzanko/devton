defmodule Devton.Subscriptions.ProcessManagers.SubscriptionsSaga do
  use Commanded.ProcessManagers.ProcessManager,
      name: "Subscriptions.ProcessManagers.SubscriptionsSaga",
      router: Devton.Router

  @derive Jason.Encoder
  defstruct []

  alias __MODULE__

  alias Devton.Subscriptions.Events.{
    SubscriptionCreated
    }

  alias Devton.Subscriptions.Commands.{}

  def interested?(%SubscriptionCreated{}), do: false
  def interested?(_event), do: false
end
