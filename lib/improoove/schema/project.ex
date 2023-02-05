defmodule Improoove.Schema.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Improoove.Schema.Stack

  schema "projects" do
    field :color, :string
    field :end_date, :utc_datetime
    field :name, :string
    field :objective, :string
    field :start_date, :utc_datetime
    field :user_id, :integer

    has_many :stack, Stack, on_delete: :delete_all
    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:user_id, :name, :objective, :start_date, :end_date, :color])
    |> validate_required([:user_id, :name, :color])
  end
end
