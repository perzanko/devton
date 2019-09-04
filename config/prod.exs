use Mix.Config

config :logger, level: :debug

config :devton, DevtonWeb.Endpoint,
       http: [:inet6, port: {:system, "PORT"}],
       secret_key_base: System.get_env("SECRET_KEY_BASE")

config :eventstore,
       column_data_type: "jsonb"

config :eventstore, EventStore.Storage,
       serializer: EventStore.JsonbSerializer,
       types: EventStore.PostgresTypes,
       url: System.get_env("EVENT_STORE_BASIC_URL"),
       pool_size: 10,
       pool_overflow: 5

config :devton, Devton.Repo,
       loggers: [{Ecto.LogEntry, :log, []}, {ScoutApm.Instruments.EctoLogger, :log, []}],
       adapter: Ecto.Adapters.Postgres,
       url: System.get_env("READ_STORE_URL"),
       pool_size: 10

config :slack,
       client_id: System.get_env("SLACK_CLIENT_ID"),
       client_secret: System.get_env("SLACK_CLIENT_SECRET"),
       root_url: System.get_env("SLACK_CLIENT_ROOT_URL")
