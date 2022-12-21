defmodule Improoove.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :log_id, :integer
      add :is_sent, :boolean, default: false, null: false

      timestamps()
    end
  end
end
