defmodule Improoove.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :color, :string
    field :end_date, :utc_datetime
    field :name, :string
    field :objective, :string
    field :start_date, :utc_datetime
    field :uid, :string

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:uid, :name, :objective, :start_date, :end_date, :color])
    |> validate_required([:uid, :name, :objective, :start_date, :end_date, :color])
  end
end
