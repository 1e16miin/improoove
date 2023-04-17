defmodule Improoove.Schema.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "reminders" do
    field :stack_id, :string
    field :message, :string
    field :remind_at, :utc_datetime
    field :deleted_at, :utc_datetime

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [:stack_id, :message, :remind_at])
    |> validate_required([:stack_id, :message, :remind_at])
  end
end
