defmodule Improoove.StacksTest do
  use Improoove.DataCase

  alias Improoove.Stacks

  describe "stacks" do
    alias Improoove.Stacks.Stack

    import Improoove.StacksFixtures

    @invalid_attrs %{description: nil, project_id: nil, type: nil, uid: nil}

    test "list_stacks/0 returns all stacks" do
      stack = stack_fixture()
      assert Stacks.list_stacks() == [stack]
    end

    test "get_stack!/1 returns the stack with given id" do
      stack = stack_fixture()
      assert Stacks.get_stack!(stack.id) == stack
    end

    test "create_stack/1 with valid data creates a stack" do
      valid_attrs = %{
        description: "some description",
        project_id: 42,
        type: "some type",
        uid: "7488a646-e31f-11e4-aace-600308960662"
      }

      assert {:ok, %Stack{} = stack} = Stacks.create_stack(valid_attrs)
      assert stack.description == "some description"
      assert stackproject_id == 42
      assert stack.type == "some type"
      assert stack.uid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_stack/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stacks.create_stack(@invalid_attrs)
    end

    test "update_stack/2 with valid data updates the stack" do
      stack = stack_fixture()

      update_attrs = %{
        description: "some updated description",
        project_id: 43,
        type: "some updated type",
        uid: "7488a646-e31f-11e4-aace-600308960668"
      }

      assert {:ok, %Stack{} = stack} = Stacks.update_stack(stack, update_attrs)
      assert stack.description == "some updated description"
      assert stackproject_id == 43
      assert stack.type == "some updated type"
      assert stack.uid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_stack/2 with invalid data returns error changeset" do
      stack = stack_fixture()
      assert {:error, %Ecto.Changeset{}} = Stacks.update_stack(stack, @invalid_attrs)
      assert stack == Stacks.get_stack!(stack.id)
    end

    test "delete_stack/1 deletes the stack" do
      stack = stack_fixture()
      assert {:ok, %Stack{}} = Stacks.delete_stack(stack)
      assert_raise Ecto.NoResultsError, fn -> Stacks.get_stack!(stack.id) end
    end

    test "change_stack/1 returns a stack changeset" do
      stack = stack_fixture()
      assert %Ecto.Changeset{} = Stacks.change_stack(stack)
    end
  end
end
