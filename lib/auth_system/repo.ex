defmodule AuthSystem.Repo do
  use Ecto.Repo,
    otp_app: :auth_system,
    adapter: Ecto.Adapters.Postgres
end
