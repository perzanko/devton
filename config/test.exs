use Mix.Config


# We don't run a server during test. If one is required,
# you can enable the server option below.
config :devton, DevtonWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn


config :commanded,
       event_store_adapter: Commanded.EventStore.Adapters.InMemory

config :commanded, Commanded.EventStore.Adapters.InMemory,
       serializer: Commanded.Serialization.JsonSerializer

config :devton, Devton.Repo,
       username: "postgres",
       password: "postgres",
       database: "devton_readstore_test",
       hostname: "localhost"
