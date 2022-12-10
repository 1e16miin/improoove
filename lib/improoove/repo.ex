defmodule Improoove.Repo do
  use Ecto.Repo,
    otp_app: :improoove,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
