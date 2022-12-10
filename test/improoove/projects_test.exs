defmodule Improoove.ProjectsTest do
  use Improoove.DataCase

  alias Improoove.Projects

  describe "projects" do
    alias Improoove.Projects.Project

    import Improoove.ProjectsFixtures

    @invalid_attrs %{
      color: nil,
      end_date: nil,
      name: nil,
      objective: nil,
      start_date: nil,
      uid: nil
    }

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{
        color: "some color",
        end_date: ~D[2022-12-02],
        name: "some name",
        objective: "some objective",
        start_date: ~D[2022-12-02],
        uid: "7488a646-e31f-11e4-aace-600308960662"
      }

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.color == "some color"
      assert project.end_date == ~D[2022-12-02]
      assert project.name == "some name"
      assert project.objective == "some objective"
      assert project.start_date == ~D[2022-12-02]
      assert project.uid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()

      update_attrs = %{
        color: "some updated color",
        end_date: ~D[2022-12-03],
        name: "some updated name",
        objective: "some updated objective",
        start_date: ~D[2022-12-03],
        uid: "7488a646-e31f-11e4-aace-600308960668"
      }

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.color == "some updated color"
      assert project.end_date == ~D[2022-12-03]
      assert project.name == "some updated name"
      assert project.objective == "some updated objective"
      assert project.start_date == ~D[2022-12-03]
      assert project.uid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end
