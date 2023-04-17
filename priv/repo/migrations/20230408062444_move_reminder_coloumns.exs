defmodule Improoove.Repo.Migrations.MoveReminderColoumns do
  use Ecto.Migration

  def change do
    alter table(:stacks) do
      remove :is_sent
      remove :sent_at
    end

    create table(:reminders) do
      add :stack_id, :int, null: false
      add :message, :string, null: false
      add :remind_at, :utc_datetime, null: false
      add :deleted_at, :utc_datetime

      time_stamps()
    end

    create_if_not_exists index("stacks", [:updated_at, :id], unique: true)
  end
end
