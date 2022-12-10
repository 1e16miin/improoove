defmodule Improoove.Stacks do
  @moduledoc """
  The Stacks context.
  """

  import Ecto.Query, warn: false
  alias Improoove.Repo

  alias Improoove.Stacks.Stack

  @doc """
  Returns the list of stacks.

  ## Examples

      iex> list_stacks()
      [%Stack{}, ...]

  """
  def list_stacks(uid, %{"cursor" => cursor, "limit" => limit}) do
    query =
      (from s in Stack,
        where: s.uid == ^uid,
        order_by: [desc: s.id])

    Repo.paginate(query,
      before: cursor,
      cursor_fields: [id: :desc],
      limit: String.to_integer(limit)
    )
  end

  def list_stacks(uid, %{"limit" => limit}) do
    query =
      (from s in Stack,
        where: s.uid == ^uid,
        order_by: [desc: s.id])

    Repo.paginate(query,
      cursor_fields: [id: :desc],
      limit: String.to_integer(limit)
    )
  end

  def list_stacks_by_project_id(project_id, type) do
    Stack
    |> where(type: ^type)
    |> where(project_id: ^project_id)
    |> order_by(desc: :id)
    |> Repo.all()
  end


  @doc """
  Gets a single stack.

  Raises `Ecto.NoResultsError` if the Stack does not exist.

  ## Examples

      iex> get_stack!(123)
      %Stack{}

      iex> get_stack!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stack!(id), do: Repo.get!(Stack, id)

  @doc """
  Creates a stack.

  ## Examples

      iex> create_stack(%{field: value})
      {:ok, %Stack{}}

      iex> create_stack(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_stack(uid, attrs) do
    attrs =
      Map.merge(%{"uid" => uid}, attrs)

    %Stack{}
    |> Stack.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a stack.

  ## Examples

      iex> update_stack(stack, %{field: new_value})
      {:ok, %Stack{}}

      iex> update_stack(stack, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stack(%Stack{} = stack, attrs) do
    stack
    |> Stack.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a stack.

  ## Examples

      iex> delete_stack(stack)
      {:ok, %Stack{}}

      iex> delete_stack(stack)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stack(%Stack{} = stack) do
    Repo.delete(stack)
  end
end
