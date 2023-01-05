defmodule Improoove.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Improoove.Repo

  alias Improoove.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects(uid, %{"cursor" => cursor, "limit" => limit}) do
    query =
      from(p in Project,
        where: p.uid == ^uid,
        order_by: [asc: p.id]
      )

    Repo.paginate(query,
      after: cursor,
      cursor_fields: [id: :asc],
      limit: String.to_integer(limit)
    )
  end

  def list_projects(uid, %{"limit" => limit}) do
    query =
      from(p in Project,
        where: p.uid == ^uid,
        order_by: [asc: p.id]
      )

    Repo.paginate(query,
      cursor_fields: [id: :asc],
      limit: String.to_integer(limit)
    )
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Repo.get!(Project, id)
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(uid, attrs) do
    attrs = Map.merge(%{"uid" => uid}, attrs)

    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end
end
