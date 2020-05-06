# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :imago,
  ecto_repos: [Imago.Repo]

# Configures the endpoint
config :imago, ImagoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TwOatoQ1FTkf8UyQ3dTQnL3CqSg+/kUguyBYX36q5BJlQ4CeZPh6SpXYTmsh9hMr",
  render_errors: [view: ImagoWeb.ErrorView, accepts: ~w(html json)]
  # pubsub: Imago.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :imago, Imago.Commanded,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: Imago.EventStore
  ],
  pub_sub: :local,
  registry: :local

# gremlin_uri = URI.parse(System.get_env("GREMLIN_URL") || "")
# config :gremlex,
#   host: gremlin_uri.host || "127.0.0.1",
#   port: gremlin_uri.port || 8182,
#   path: gremlin_uri.path || "/gremlin",
#   pool_size: 10,
#   secure: false,
#   ping_delay: 60_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
