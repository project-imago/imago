defmodule Imago.Repo do
  use Ecto.Repo,
    otp_app: :imago,
    adapter: Ecto.Adapters.Postgres
end
