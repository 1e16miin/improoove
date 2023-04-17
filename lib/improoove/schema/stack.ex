defmodule Improoove.Schema.Stack do
  alias Improoove.Schema.Reminder
  use Ecto.Schema
  import Ecto.Changeset

  schema "stacks" do
    field :description, :string
    field :project_id, :integer
    field :type, Ecto.Enum, values: [:FEEDBACK, :LOG]
    field :user_id, :integer

    has_many :reminder, Reminder, foreign_key: :stack_id, references: :id, on_delete: :delete_all
    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [:project_id, :user_id, :description, :type])
    |> validate_required([:project_id, :user_id, :description, :type])
  end
end
