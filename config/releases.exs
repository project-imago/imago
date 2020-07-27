# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :imago, Imago.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

endpoint_url =
  System.get_env("ENDPOINT_URL") ||
    raise """
    environment variable ENDPOINT_URL is missing.
    """

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :imago, ImagoWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.get_env("PORT") || "4000")],
  url: [host: endpoint_url, port: 443],
  secret_key_base: secret_key_base

wdqs_url =
  System.get_env("WDQS_URL") ||
    raise """
    environment variable WDQS_URL is missing.
    """

config :imago, Imago.Graph,
  endpoint: wdqs_url

matrix_url =
  System.get_env("MATRIX_URL") ||
    raise """
    environment variable MATRIX_URL is missing.
    """

matrix_as_token =
  System.get_env("MATRIX_AS_TOKEN") ||
    raise """
    environment variable MATRIX_AS_TOKEN is missing.
    """

matrix_hs_token =
  System.get_env("MATRIX_HS_TOKEN") ||
    raise """
    environment variable MATRIX_HS_TOKEN is missing.
    """

config :matrix_app_service,
  base_url: matrix_url,
  access_token: matrix_as_token,
  homeserver_token: matrix_hs_token

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:

config :imago, ImagoWeb.Endpoint, server: true

# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
