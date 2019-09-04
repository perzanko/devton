defmodule Devton.Repo do
  use Ecto.Repo,
      otp_app: :devton,
      adapter: Ecto.Adapters.Postgres

  @dialyzer {:nowarn_function, rollback: 1}
end
