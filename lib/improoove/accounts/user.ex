defmodule Improoove.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uid, Ecto.UUID

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid])
    |> validate_required([:uid])
  end
end
