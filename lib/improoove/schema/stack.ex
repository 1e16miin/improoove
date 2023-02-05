defmodule Improoove.Schema.Stack do
  alias Improoove.Schema.Tag
  use Ecto.Schema
  import Ecto.Changeset

  schema "stacks" do
    field :description, :string
    field :project_id, :integer
    field :type, Ecto.Enum, values: [:FEEDBACK, :LOG]
    field :user_id, :integer
    field :is_sent, :boolean
    field :sent_at, :utc_datetime

    #_has_many :tag, Tag, where: [type: :LOG], foreign_key: :log_id, references: :id, on_delete: :delete_all
    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [:project_id, :user_id, :description, :type])
    |> validate_required([:project_id, :user_id, :description, :type])
  end
end
