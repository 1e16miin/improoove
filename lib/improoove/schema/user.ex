defmodule Improoove.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uid, Ecto.UUID, default: Ecto.UUID.generate()

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
