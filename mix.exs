defmodule Imago.MixProject do
  use Mix.Project

  def project do
    [
      app: :imago,
      version: "0.1.0",
      elixir: "~> 1.7",
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
      mod: {Imago.Application, []},
      extra_applications: [:logger, :runtime_tools, :eventstore]
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
      {:phoenix, "~> 1.5.1"},
      {:phoenix_pubsub, "~> 2.0", override: true}, # temporary until new version of commanded
      {:phoenix_ecto, "~> 4.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:ecto_sql, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:commanded, "~> 1.0.0"},
      {:commanded_eventstore_adapter, "~> 1.0.0"},
      {:cors_plug, "~> 2.0"},
      # {:pbf_parser, "~> 0.1.2"}
      # {:gremlex, "~> 0.1.1"},

      {:sparql_client,
        git: "https://gitlab.com/imago-project/sparql_client.git",
        ref: "2c7114ec78eb56d27b8d9cdcc7cedaa99e3041ea"},
      # {:sparql_client, "~> 0.2.2", path: "./sparql_client"},

      {:polyjuice_client,
        git: "https://gitlab.com/imago-project/polyjuice_client.git",
        branch: "create_room",
        override: true},
      # {:polyjuice_client, "~> 0.2.2", path: "./polyjuice_client", override: true},

      {:matrix_app_service,
        git: "https://gitlab.com/imago-project/matrix_app_service.ex.git",
        branch: "master"}
      # {:matrix_app_service, "~> 0.1.0", path: "./matrix_app_service"}
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
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
