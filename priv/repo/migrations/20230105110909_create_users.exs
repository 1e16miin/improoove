defmodule Improoove.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uid, :string

      timestamps()
    end
  end
end
