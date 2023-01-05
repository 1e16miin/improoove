defmodule Improoove.Tags.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :log_id, :integer
    field :name, :string

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:log_id, :name])
    |> validate_required([:log_id, :name])
  end
end
