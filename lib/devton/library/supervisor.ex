defmodule Devton.Library.Supervisor do
  use Supervisor

  alias Devton.Library.Projectors

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(arg) do
    children = [
      # Projectors
      worker(Projectors.TagCreated, [], id: :tag_created_projector),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
