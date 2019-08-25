defmodule Devton.Repo do
  use Ecto.Repo,
      otp_app: :devton,
      adapter: Ecto.Adapters.Postgres
end
