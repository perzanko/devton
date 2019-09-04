# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :devton,
  ecto_repos: [Devton.Repo]

config :devton, env: Mix.env

# Configures the endpoint
config :devton, DevtonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2N9rPSczc8VX7njy2GWc7d5cXWMAMsqQfzzlh+vdjOljKC9lpluqYNYXXMdfFC4t",
  render_errors: [view: DevtonWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Devton.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :commanded, event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :commanded_ecto_projections,
       repo: Devton.Repo

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :devton, Devton.Scheduler,
      global: true,
      debug_logging: false,
      jobs: [
        {"0 1 * * *", {DevtonAggregator.TagsAggregator, :aggregate, []}},
        {"0 4 * * *", {DevtonAggregator.ArticlesAggregator, :aggregate, []}},
      ]

