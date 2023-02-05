defmodule Improoove.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :user_id, :int, null: false
      add :name, :string, size: 30, null: false
      add :objective, :string, size: 30
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :color, :string, null: false

      timestamps()
    end
  end
end
