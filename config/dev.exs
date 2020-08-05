import Config

# Configure your database
config :imago, Imago.Repo,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "imago_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# Configure the event store database
config :imago, Imago.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "imago_eventstore_dev",
  hostname: System.get_env("POSTGRES_HOST") || "localhost",
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :imago, ImagoWeb.Endpoint,
  http: [port: 4000],
  # https: [
  #   port: 4001,
  #   cipher_suite: :strong,
  #   certfile: "priv/cert/selfsigned.pem",
  #   keyfile: "priv/cert/selfsigned_key.pem"
  # ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    # node: [
    #   "node_modules/webpack/bin/webpack.js",
    #   "--mode",
    #   "development",
    #   "--watch-stdin",
    #   cd: Path.expand("../assets", __DIR__)
    # ]
  ]

config :cors_plug,
  origin: "*"

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :imago, ImagoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/imago_web/{live,views}/.*(ex)$",
      ~r"lib/imago_web/templates/.*(eex)$"
    ]
  ]

# config :imago, :rdf,
#   root_iri: "http://imago.local"

config :imago, Imago.Graph,
  endpoint: "http://wdqs:9999/bigdata/namespace/wdq/sparql"

config :matrix_app_service,
  path: "/api/matrix",
  base_url: "http://synapse:8008",
  access_token: "MDAyMGxvY2F0aW9uIG1hdHJpeC5pbWFnby5sb2NhbAowMDEzaWRlbnRpZmllciBrZXkKMDAxMGNpZCBnZW4gPSAxCjAwMmNjaWQgdXNlcl9pZCA9IEBhbGljZTptYXRyaXguaW1hZ28ubG9jYWwKMDAxNmNpZCB0eXBlID0gYWNjZXNzCjAwMjFjaWQgbm9uY2UgPSAjRC5ieWJrMEUuMU0qT0xJCjAwMmZzaWduYXR1cmUg-jGyjY9CK07mRt1h4p_86D6SJr1ZqrGr8YlsIW_jLtMK",
  homeserver_token: "MDAyMGxvY2F0aW9uIG1hdHJpeC5pbWFnby5sb2NhbAowMDEzaWRlbnRpZmllciBrZXkKMDAxMGNpZCBnZW4gPSAxCjAwMmNjaWQgdXNlcl9pZCA9IEBhbGljZTptYXRyaXguaW1hZ28ubG9jYWwKMDAxNmNpZCB0eXBlID0gYWNjZXNzCjAwMjFjaWQgbm9uY2UgPSBjcX4jazVTUDNeUlk2WnRECjAwMmZzaWduYXR1cmUg_K2biF-xm5ue7985RkAomVadF7yfy3UiEpH-e15m0esK"

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
