defmodule ImproooveWeb.TagControllerTest do
  use ImproooveWeb.ConnCase

  import Improoove.TagsFixtures

  alias Improoove.Tags.Tag

  @create_attrs %{
    log_id: 42,
    name: "some name"
  }
  @update_attrs %{
    log_id: 43,
    name: "some updated name"
  }
  @invalid_attrs %{log_id: nil, name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tags", %{conn: conn} do
      conn = get(conn, Routes.tag_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tag" do
    test "renders tag when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "log_id" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tag_path(conn, :create), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tag" do
    setup [:create_tag]

    test "renders tag when data is valid", %{conn: conn, tag: %Tag{id: id} = tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tag_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "log_id" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tag: tag} do
      conn = put(conn, Routes.tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tag" do
    setup [:create_tag]

    test "deletes chosen tag", %{conn: conn, tag: tag} do
      conn = delete(conn, Routes.tag_path(conn, :delete, tag))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tag_path(conn, :show, tag))
      end
    end
  end

  defp create_tag(_) do
    tag = tag_fixture()
    %{tag: tag}
  end
end
