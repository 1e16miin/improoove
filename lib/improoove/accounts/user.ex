defmodule Improoove.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :uid, :string

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:uid])
    |> validate_required([:uid])
    |> put_uid_hash()
  end

  defp put_uid_hash(%Ecto.Changeset{valid?: true, changes: %{uid: uid}} = changeset) do
    change(changeset, Bcrypt.add_hash(uid, [hash_key: :uid]))
  end
end
