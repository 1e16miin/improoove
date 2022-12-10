defmodule ImproooveWeb.ProjectController do
  use ImproooveWeb, :controller
  use PhoenixSwagger
  import Plug.Conn

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
            color(:string, "project main color", required: true)
            objective(:string, "goal of project", required: true)
            endDate(:string, "when finish project", format: "ISO-8601")
            startDate(:string, "when start project", format: "ISO-8601")
            name(:string, "name of project", required: true)
          end
          example %{
            color: "#000000",
            objective: "objective",
            endDate: "2020-10-10T00:00:00Z",
            startDate: "2020-10-01T00:00:00Z",
            name: "name"
          }
        end,
      UpdateProjectInput:
        swagger_schema do
          title("UpdateProjectInput")
          description("Update Schema of project")

          properties do
            color(:string, "project main color")
            objective(:string, "goal of project")
            endDate(:string, "when finish project", format: "ISO-8601")
            startDate(:string, "when start project", format: "ISO-8601")
            name(:string, "name of project", required: true)
          end
          example %{
            color: "#000000",
            objective: "objective",
            endDate: "2020-10-10T00:00:00Z",
            startDate: "2020-10-01T00:00:00Z",
            name: "name"
          }
        end,
      Project:
        swagger_schema do
          title("Project")
          description("")

          properties do
            id(:integer, "The ID of project", required: true)
            color(:string, "project main color", required: true)
            objective(:string, "goal of project", required: true)
            endDate(:string, "when finish project", format: "ISO-8601")
            startDate(:string, "when start project", format: "ISO-8601")
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
    logs = Stacks.list_stacks_by_project_id(id, "LOG")
    feedbacks = Stacks.list_stacks_by_project_id(id, "FEEDBACK")

    project
    |> Map.put(:logs, logs)
    |> Map.put(:feedbacks, feedbacks)
  end

  swagger_path :index do
    get("/api/project/index")
    summary("Query for projects")
    description("Query for projects. This operation supports with paging and filtering")
    produces("application/json")
    tag("Project")
    operation_id("list_projects")
    CommonParameters.authorization()
    CommonParameters.pagination()
    response(200, "OK", Schema.ref(:Projects))
    response(400, "Bad Request")
    response(404, "Not Found")
  end

  def index(conn, args) do
    [uid] = get_req_header(conn, "authorization")
    %{entries: entries, metadata: page_info} = Projects.list_projects(uid, args)
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
    CommonParameters.authorization()

    parameters do
      project(:body, Schema.ref(:CreateProjectInput), "project attributes")
    end

    response(201, "OK", Schema.ref(:Project))
    response(422, "Validation Error")
  end

  def create(conn, project_params) do
    [uid] = get_req_header(conn, "authorization")

    with {:ok, %Project{} = project} <- Projects.create_project(uid, project_params) do
      new_project =
        project
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
    CommonParameters.authorization()

    parameters do
      id(:path, :string, "project ID", required: true)
    end

    response(200, "OK", Schema.ref(:Project))
    response(400, "Bad Request")
  end

  def show(conn, %{"id" => id}) do
    [uid] = get_req_header(conn, "authorization")
    project =
      Projects.get_project!(id)
      |> make_project
      |> IO.inspect()

    render(conn, "show.json", project: project)
  end

  swagger_path :update do
    patch("/api/project/:id")
    summary("update project")
    description("update project. This operation supports updating")
    produces("application/json")
    tag("Project")
    operation_id("update_project")
    CommonParameters.authorization()

    parameters do
      id(:path, :string, "project ID", required: true)
      project(:body, Schema.ref(:UpdateProjectInput), "partial project attributes")
    end

    response(201, "OK", Schema.ref(:Project))
    response(422, "Validation Error")
  end

  def update(conn, %{"id" => id} = project_param) do
    [uid] = get_req_header(conn, "authorization")
    project = Projects.get_project!(id)

    with {:ok, %Project{} = project} <- Projects.update_project(project, project_param) do
      render(conn, "show.json", project: project)
    end
  end

  swagger_path :remove do
    delete("/api/project/{id}")
    summary("delete project")
    description("Delete project. This operation supports deleting")
    produces("application/json")
    tag("Project")
    operation_id("delete_project")
    CommonParameters.authorization()

    parameters do
      id(:path, :string, "project ID", required: true)
    end

    response(204, "No Content")
    response(400, "Bad Request")
  end

  def remove(conn, %{"id" => id}) do
    [uid] = get_req_header(conn, "authorization")
    project = Projects.get_project!(id)

    with {:ok, %Project{}} <- Projects.delete_project(project) do
      send_resp(conn, :no_content, "")
    end
  end
end
