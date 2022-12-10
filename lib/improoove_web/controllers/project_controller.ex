defmodule ImproooveWeb.ProjectController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Projects
  alias Improoove.Projects.Project
  alias Improoove.Stacks

  action_fallback ImproooveWeb.FallbackController

  def swagger_definitions do
    %{
      CreateProjectInput:
        swagger_schema do
          title("CreateProjectInput")
          description("Input Schema of project")

          properties do
            uid(:string, "The ID of user", required: true)
            color(:string, "project main color", required: true)
            objective(:string, "goal of project", required: true)
            end_date(:string, "when finish project", format: "ISO-8601")
            start_date(:string, "when start project", format: "ISO-8601")
            name(:string, "name of project", required: true)
          end
        end,

      UpdateProjectInput:
        swagger_schema do
          title("UpdateProjectInput")
          description("Update Schema of project")

          properties do
            uid(:string, "The ID of user", required: true)
            color(:string, "project main color")
            objective(:string, "goal of project")
            end_date(:string, "when finish project", format: "ISO-8601")
            start_date(:string, "when start project", format: "ISO-8601")
            name(:string, "name of project", required: true)
          end
        end,

      Project:
        swagger_schema do
          title("Project")
          description("")

          properties do
            uid(:string, "The ID of user", required: true)
            color(:string, "project main color", required: true)
            objective(:string, "goal of project", required: true)
            end_date(:string, "when finish project", format: "ISO-8601")
            start_date(:string, "when start project", format: "ISO-8601")
            name(:string, "name of project", required: true)
            logs(Schema.ref(:Stacks))
            feedbacks(Schema.ref(:Stacks))
          end
        end,

      Projects:
        swagger_schema do
          title("Projects")
          description("A collection of Users")
          type(:array)
          items(Schema.ref(:Project))
        end
    }
  end

  defp make_project(%{id: id} = project) do
    logs = Stacks.list_stacks(id, "LOG")
    feedbacks = Stacks.list_stacks(id, "FEEDBACK")

    project
    |> Map.put(:logs, logs)
    |> Map.put(:feedbacks, feedbacks)
  end

  swagger_path :index do
    get("/api/project/index/{uid}")
    summary("Query for projects")
    description("Query for projects. This operation supports with paging and filtering")
    produces("application/json")
    tag("Project")
    operation_id("list_projects")
    paging(size: "page_size", offset: "cursor")
    parameters do
      uid(:path, :string, "user ID", required: true)
      page_size(:query, :integer, "page size")
      cursor(:query, :integer, "cursor")
    end

    response(200, "OK", Schema.ref(:Projects))
    response(400, "Client Error")
  end

  def index(conn, %{"uid" => uid, "page_size" => page_size, "cursor" => cursor}) do
    %{entries: entries, metadata: page_info} = Projects.list_projects(uid, page_size, cursor)
    projects = Enum.map(entries, fn project -> make_project(project) end)
    render(conn, "index.json", projects: projects, page_info: page_info)
  end

  swagger_path :create do
    post("/api/project")
    summary("create project")
    description("Create project. This operation supports creating")
    produces("application/json")
    tag("Project")
    operation_id("create_project")

    parameters do
      project(:body, Schema.ref(:CreateProjectInput), "project attributes")
    end

    response(201, "OK", Schema.ref(:Project))
    response(422, "Validation Error")
  end

  def create(conn, project_params) do
    IO.inspect(project_params)
    with {:ok, %Project{} = project} <- Projects.create_project(project_params) do
      new_project = project
      |> Map.put(:logs, [])
      |> Map.put(:feedbacks, [])

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.project_path(conn, :show, new_project))
      |> render("show.json", project: new_project)
    end
  end

  swagger_path :show do
    get("/api/project/{id}")
    summary("Query for project")
    description("Query for project. This operation supports filtering")
    produces("application/json")
    tag("Project")
    operation_id("get_project!")

    parameters do
      id(:path, :string, "project ID", required: true)
    end

    response(200, "OK", Schema.ref(:Project))
    response(400, "Bad Request")
  end

  def show(conn, %{"id" => id}) do
    project =
      Projects.get_project!(id)
      |> make_project

    render(conn, "show.json", project: project)
  end

  swagger_path :update do
    patch("/api/project/{id}")
    summary("update project")
    description("update project. This operation supports updating")
    produces("application/json")
    tag("Project")
    operation_id("update_project")

    parameters do
      id(:path, :string, "project ID", required: true)
      project(:body, Schema.ref(:UpdateProjectInput), "partial project attributes")
    end

    response(201, "OK", Schema.ref(:Project))
    response(422, "Validation Error")
  end

  def update(conn, %{"id" => id, "project" => project_param}) do
    {id, _} = Integer.parse(id)
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_params) do
      render(conn, "show.json", project: project)
    end
  end

  swagger_path :remove do
    delete("/api/project/{project_id}")
    summary("delete project")
    description("Delete project. This operation supports deleting")
    produces("application/json")
    tag("Project")
    operation_id("delete_project")

    parameters do
      id(:path, :string, "project ID", required: true)
    end

    response(200, "OK", Schema.ref(:Project))
    response(400, "Client Error")
  end

  def remove(conn, %{"id" => id}) do
    project = Projects.get_project!(id)

    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
