defmodule Dubi.Repo do
  use Ecto.Repo,
    otp_app: :dubi,
    adapter: Ecto.Adapters.Postgres
end
