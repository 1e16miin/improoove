defmodule Improoove.Schema.Device do
  use Ecto.Schema
  import Ecto.Changeset

  schema "devices" do
    field :user_id, :integer
    field :os, Ecto.Enum, values: [:IOS, :ANDROID]
    field :token, :string

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:id, :user_id, :os, :token])
    |> validate_required([:id, :user_id, :os, :token])
  end
end
