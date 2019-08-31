defmodule Devton.MixProject do
  use Mix.Project

  def project do
    [
      app: :devton,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Devton.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:commanded, "~> 0.19"},
      {:eventstore, "~> 0.17.0", runtime: Mix.env() != :test},
      {:commanded_eventstore_adapter, "~> 0.6", runtime: Mix.env() != :test},
      {:commanded_ecto_projections, "~> 0.8"},
      {:skooma, "~> 0.2.0"},
      {:slack, "~> 0.19.0"},
      {:quantum, "~> 2.3"},
      {:timex, "~> 3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "read_store.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "read_store.reset": ["ecto.drop", "read_store.setup"],
      "read_store.migrate": ["ecto.migrate"],
      "event_store.setup": ["event_store.create", "event_store.init"],
      "event_store.reset": ["event_store.drop", "event_store.create", "event_store.init"],
      test: ["read_store.reset", "test"]
    ]
  end
end
