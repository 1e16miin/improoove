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

  def list_projects(user_id, %{"cursor" => cursor, "limit" => limit, "status" => "FINISHED"}) do
    IO.inspect("1")
    query =
      from(p in Project,
        where: p.user_id == ^user_id and not is_nil(p.end_date),
        order_by: [asc: p.end_date]
      )

    Repo.paginate(query,
      after: cursor,
      cursor_fields: [end_date: :asc],
      limit: limit)
  end

  def list_projects(user_id, %{"cursor" => cursor, "limit" => limit, "status" => "PROCEEDING"}) do
    IO.inspect("2")
    query =
      from(p in Project,
        where: p.user_id == ^user_id and is_nil(p.end_date),
        order_by: [desc: p.start_date]
      )

    Repo.paginate(query,
      after: cursor,
      cursor_fields: [start_date: :desc],
      limit: limit
    )
  end

  def list_projects(user_id, %{"cursor" => cursor, "limit" => limit}) do
    query =
      from(p in Project,
        where: p.user_id == ^user_id,
        order_by: [asc: p.id]
      )

    Repo.paginate(query,
      after: cursor,
      cursor_fields: [id: :asc],
      limit: limit
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
  def create_project(user_id, attrs) do
    attrs = Map.merge(%{"user_id" => user_id}, attrs)

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
