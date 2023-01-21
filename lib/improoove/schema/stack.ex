defmodule Improoove.Schema.Stack do
  alias Improoove.Schema.Reminder
  use Ecto.Schema
  import Ecto.Changeset

  schema "stacks" do
    field :description, :string
    field :project_id, :integer
    field :type, :string
    field :user_id, :integer

    has_many :reminder, Reminder
    has_many :tag, Tag
    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [:project_id, :user_id, :description, :type])
    |> validate_required([:project_id, :user_id, :description, :type])
  end
end
