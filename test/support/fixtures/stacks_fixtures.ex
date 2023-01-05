defmodule Improoove.StacksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Improoove.Stacks` context.
  """

  @doc """
  Generate a stack.
  """
  def stack_fixture(attrs \\ %{}) do
    {:ok, stack} =
      attrs
      |> Enum.into(%{
        description: "some description",
        project_id: 42,
        type: "some type",
        uid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Improoove.Stacks.create_stack()

    stack
  end
end
