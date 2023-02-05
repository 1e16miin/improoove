defmodule Improoove.Repo.Migrations.CreateStacks do
  use Ecto.Migration

  def change do
    create table(:stacks) do
      add :project_id, :int, default: 0, null: false
      add :user_id, :int, null: false
      add :description, :string, null: false
      add :type, :string, null: false

      timestamps()
    end
  end
end
