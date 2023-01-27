defmodule Improoove.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :user_id, :integer, null: false
      add :os, :string, null: false
      add :token, :string, null: false

      timestamps()
    end
  end
end
