defmodule ChoreDo.Repo do
  use Ecto.Repo,
    otp_app: :chore_do,
    adapter: Ecto.Adapters.Postgres
end
