defmodule Improoove.Stacks.Stack do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stacks" do
    field :description, :string
    field :project_id, :integer
    field :type, :string
    field :uid, :string
    field :remind, :integer

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(stack, attrs) do
    stack
    |> cast(attrs, [:project_id, :uid, :description, :type, :remind])
    |> validate_required([:project_id, :uid, :description, :type, :remind])
  end
end
