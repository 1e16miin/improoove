defmodule Improoove.Reminders.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminders" do
    field :is_sent, :boolean, default: false
    field :log_id, :integer

    timestamps()
  end

  @doc false
  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs, [:log_id, :is_sent])
    |> validate_required([:log_id, :is_sent])
  end
end
