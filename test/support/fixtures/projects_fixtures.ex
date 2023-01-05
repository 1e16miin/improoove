defmodule Improoove.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Improoove.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        color: "some color",
        end_date: ~D[2022-12-02],
        name: "some name",
        objective: "some objective",
        start_date: ~D[2022-12-02],
        uid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Improoove.Projects.create_project()

    project
  end
end
