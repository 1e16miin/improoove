defmodule Improoove.Repo do
  use Ecto.Repo,
    otp_app: :improoove,
    adapter: Ecto.Adapters.Postgres

  use Paginator,
    limit: 10,
    maximum_limit: 100,
    include_total_count: true

  use Ecto.SoftDelete.Repo
end
