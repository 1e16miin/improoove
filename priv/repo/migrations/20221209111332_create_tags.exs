defmodule Improoove.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :log_id, :integer
      add :name, :string

      timestamps()
    end
  end
end
