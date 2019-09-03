use Mix.Config

config :logger, level: :debug

config :devton, DevtonWeb.Endpoint,
       http: [:inet6, port: System.get_env("PORT")],
       secret_key_base: System.get_env("SECRET_KEY_BASE")

config :eventstore,
       column_data_type: "jsonb"

config :eventstore, EventStore.Storage,
       serializer: EventStore.JsonbSerializer,
       types: EventStore.PostgresTypes,
       url: System.get_env("EVENT_STORE"),
       pool_size: 10,
       pool_overflow: 5

config :devton, Devton.Repo,
       adapter: Ecto.Adapters.Postgres,
       url: System.get_env("READ_STORE"),
       pool_size: 10

config :slack,
       client_id: System.get_env("SLACK_CLIENT_ID"),
       client_secret: System.get_env("SLACK_CLIENT_SECRET"),
       root_url: System.get_env("SLACK_CLIENT_ROOT_URL")
