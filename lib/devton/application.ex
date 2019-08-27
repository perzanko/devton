defmodule Devton.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Devton.Repo, []),
      supervisor(DevtonWeb.Endpoint, []),
      supervisor(Devton.Workspaces.Supervisor, []),
      supervisor(DevtonSlack.Manager, [])
    ]

    opts = [strategy: :one_for_one, name: Devton.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    DevtonWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
