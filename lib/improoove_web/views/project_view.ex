defmodule ImproooveWeb.ProjectView do
  use ImproooveWeb, :view
  alias ImproooveWeb.ProjectView

  def render("index.json", %{projects: projects, page_info: page_info}) do
    %{
      data: render_many(projects, ProjectView, "project.json"),
      page_info: %{
        after: page_info.after,
        limit: page_info.limit,
        total_count: page_info.total_count
      }
    }
  end

  def render("show.json", %{project: project}) do
    %{data: render_one(project, ProjectView, "project.json")}
  end

  def render("project.json", %{project: project}) do
    %{
      id: project.id,
      name: project.name,
      objective: project.objective,
      start_date: project.start_date,
      end_date: project.end_date,
      color: project.color,
      logs: project.logs,
      feedbacks: project.feedbacks
    }
  end
end
