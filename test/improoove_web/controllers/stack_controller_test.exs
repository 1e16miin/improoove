defmodule ImproooveWeb.StackControllerTest do
  use ImproooveWeb.ConnCase

  import Improoove.StacksFixtures

  alias Improoove.Stacks.Stack

  @create_attrs %{
    description: "some description",
    project_id: 42,
    type: "some type",
    uid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    description: "some updated description",
    project_id: 43,
    type: "some updated type",
    uid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{description: nil, project_id: nil, type: nil, uid: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all stacks", %{conn: conn} do
      conn = get(conn, Routes.stack_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create stack" do
    test "renders stack when data is valid", %{conn: conn} do
      conn = post(conn, Routes.stack_path(conn, :create), stack: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.stack_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "project_id" => 42,
               "type" => "some type",
               "uid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.stack_path(conn, :create), stack: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stack" do
    setup [:create_stack]

    test "renders stack when data is valid", %{conn: conn, stack: %Stack{id: id} = stack} do
      conn = put(conn, Routes.stack_path(conn, :update, stack), stack: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.stack_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "project_id" => 43,
               "type" => "some updated type",
               "uid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, stack: stack} do
      conn = put(conn, Routes.stack_path(conn, :update, stack), stack: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stack" do
    setup [:create_stack]

    test "deletes chosen stack", %{conn: conn, stack: stack} do
      conn = delete(conn, Routes.stack_path(conn, :delete, stack))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.stack_path(conn, :show, stack))
      end
    end
  end

  defp create_stack(_) do
    stack = stack_fixture()
    %{stack: stack}
  end
end
