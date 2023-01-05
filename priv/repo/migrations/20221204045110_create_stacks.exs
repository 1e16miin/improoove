defmodule Improoove.Repo.Migrations.CreateStacks do
  use Ecto.Migration

  def change do
    create table(:stacks) do
      add :project_id, :int, default: 0, null: false
      add :uid, :string, null: false
      add :remind, :int
      add :description, :string, null: false
      add :type, :string, null: false

      timestamps()
    end
  end
end
