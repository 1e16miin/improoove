defmodule Improoove.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uid, Ecto.UUID

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(user) do
    user
    |> Map.put(:uid, Ecto.UUID.generate())
    |> cast(%{}, [])
    |> validate_required([])
  end
end
