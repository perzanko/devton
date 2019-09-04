use Mix.Config

config :eventstore,
       column_data_type: "jsonb"

config :eventstore, EventStore.Storage,
       serializer: EventStore.JsonbSerializer,
       types: EventStore.PostgresTypes,
       username: "postgres",
       password: "postgres",
       database: "devton_eventstore_dev",
       hostname: "localhost",
       pool_size: 10,
       pool_overflow: 5

config :devton, Devton.Repo,
       adapter: Ecto.Adapters.Postgres,
       username: "postgres",
       password: "postgres",
       database: "devton_readstore_dev",
       hostname: "localhost",
       pool_size: 10


# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :devton, DevtonWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :devton, DevtonWeb.Endpoint,
       live_reload: [
         patterns: [
           ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
           ~r"priv/gettext/.*(po)$",
           ~r"lib/devton_web/{live,views}/.*(ex)$",
           ~r"lib/devton_web/templates/.*(eex)$"
         ]
       ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :slack,
       client_id: System.get_env("SLACK_CLIENT_ID"),
       client_secret: System.get_env("SLACK_CLIENT_SECRET"),
       root_url: "http://localhost:4000/api/slack/auth"
