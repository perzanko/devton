use Mix.Config

config :logger, level: :debug

config :devton, DevtonWeb.Endpoint,
       http: [:inet6, port: System.get_env("PORT")],
       secret_key_base: "VHVUlsvU/+jfsQuFe/gUYethV7V5HN0ZiUqFaCFvhwQJF2Te5Lh7F7pQGa90acLo"

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
       client_id: "739395409799.739716238054",
       client_secret: "5eda2093e92aba482bdd73ba52662af2",
       root_url: "http://159.65.222.14:4000/api/slack/auth"

import_config "prod.secret.exs"
