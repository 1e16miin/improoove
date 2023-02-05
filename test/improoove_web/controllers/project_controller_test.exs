defmodule ImproooveWeb.ProjectControllerTest do
  use ImproooveWeb.ConnCase

  import Improoove.ProjectsFixtures

  alias Improoove.Projects.Project

  @create_attrs %{
    color: "some color",
    end_date: ~D[2022-12-02],
    name: "some name",
    objective: "some objective",
    start_date: ~D[2022-12-02],
    uid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    color: "some updated color",
    end_date: ~D[2022-12-03],
    name: "some updated name",
    objective: "some updated objective",
    start_date: ~D[2022-12-03],
    uid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{
    color: nil,
    end_date: nil,
    name: nil,
    objective: nil,
    start_date: nil,
    uid: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, Routes.project_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_path(conn, :create), project: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.project_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "color" => "some color",
               "end_date" => "2022-12-02",
               "name" => "some name",
               "objective" => "some objective",
               "start_date" => "2022-12-02",
               "uid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_path(conn, :create), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      conn = put(conn, Routes.project_path(conn, :update, project), project: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.project_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "color" => "some updated color",
               "end_date" => "2022-12-03",
               "name" => "some updated name",
               "objective" => "some updated objective",
               "start_date" => "2022-12-03",
               "uid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, Routes.project_path(conn, :update, project), project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, Routes.project_path(conn, :delete, project))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.project_path(conn, :show, project))
      end
    end
  end

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end
end
