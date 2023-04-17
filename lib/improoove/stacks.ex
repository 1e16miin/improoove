defmodule Improoove.Stacks do
  @moduledoc """
  The Stacks context.
  """

  import Ecto.Query, warn: false
  alias Improoove.Schedulers.Reminder
  alias Improoove.Repo

  alias Improoove.Schema.Stack

  @doc """
  Returns the list of stacks.

  ## Examples

      iex> list_stacks()
      [%Stack{}, ...]

  """
  def list_stacks(user_id, %{"cursor" => cursor, "limit" => limit}) do
    query =
      from s in Stack,
        where: s.user_id == ^user_id,
        order_by: [desc: s.updated_at]

    Repo.paginate(query,
      after: cursor,
      cursor_fields: [updated_at: :desc],
      limit: String.to_integer(limit)
    )
  end

  def list_stacks(user_id, %{"limit" => limit}) do
    query =
      from s in Stack,
        where: s.user_id == ^user_id,
        order_by: [desc: s.updated_at]

    Repo.paginate(query,
      cursor_fields: [updated_at: :desc],
      limit: String.to_integer(limit)
    )
  end

  def list_stacks(_user_id, %{"project_id" => project_id, "type" => type}) do
    Stack
    |> where(type: ^type)
    |> where(project_id: ^project_id)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def list_stacks(_user_id, %{"project_id" => project_id}) do
    Stack
    |> where(project_id: ^project_id)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def list_stacks(_user_id, %{"is_sent" => is_sent}) do
    Stack
    |> where(is_sent: ^is_sent)
    |> where(not is_nil(:sent_at))
    |> order_by(asc: :sent_at)
    |> Repo.all()
  end

  def count_stacks(project_id, type) do
    Stack
    |> where(type: ^type)
    |> where(project_id: ^project_id)
    |> select(count("*"))
    |> Repo.one!()
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
  def create_stack(user_id, attrs) do
    attrs = Map.merge(%{"user_id" => user_id}, attrs)

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

  # def update_stack(%Stack{sent_at: sent_at, id: id} = stack, %{sent_at: nil} = attrs)
  #     when not is_nil(sent_at) do
  #   stack
  #   |> Stack.changeset(attrs)
  #   |> Repo.update()

  #   Reminder.cancel_scheduled_item(Improoove.Reminder, "reminder-stack-#{id}")
  # end

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

  def delete_stacks_by_project_id(project_id) do
    from(s in Stack, where: s.project_id == ^project_id)
    |> Repo.delete_all()
  end
end
