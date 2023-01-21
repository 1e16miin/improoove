defmodule Improoove.Repo.Migrations.AlterStacks do
  use Ecto.Migration

  def change do
    alter table(:stacks) do
      add :is_sent, :boolean, null: false, default: false
      add :sent_at, :utc_datetime
    end

    create_if_not_exists index("stacks", [:updated_at, :id], [unique: true])
  end
end
