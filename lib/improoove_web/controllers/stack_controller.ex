defmodule ImproooveWeb.StackController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Stacks
  alias Improoove.Schema.Stack

  action_fallback ImproooveWeb.FallbackController

  def swagger_definitions do
    %{
      CreateStackInput:
        swagger_schema do
          title("Create Stack Input")
          description("Create Schema of Log and Feedback")

          properties do
            projectId(:integer, "ID of project", required: true)
            description(:string, "When was the activity last updated", required: true)
            type(:string, "type of stack", required: true, enum: ["LOG", "FEEDBACK"])
          end

          example(%{
            projectId: 1,
            description: "description",
            type: "LOG"
          })
        end,
      UpdateStackInput:
        swagger_schema do
          title("Update Stack Input")
          description("Update Schema of Log and Feedback")

          properties do
            description(:string, "When was the activity last updated", required: true)
          end
        end,
      Stack:
        swagger_schema do
          title("Stack")
          description("Stack")

          properties do
            id(:integer, "The ID of stack", required: true)
            projectId(:integer, "ID of project", required: true)
            description(:string, "description of stack", required: true)
            createdAt(:string, "when created log or feedback", format: "ISO-8601")
            type(:string, "type of stack", required: true, enum: ["LOG", "FEEDBACK"])
          end
        end,
      Stacks:
        swagger_schema do
          title("Stacks")
          description("A collection of Stacks")
          type(:array)
          items(Schema.ref(:Stack))
        end
    }
  end

  swagger_path :index do
    get("/api/stack/index")
    summary("Query for stacks")
    description("Query for Stacks. This operation supports with paging and filtering")
    produces("application/json")
    tag("Stack")
    operation_id("list_stacks")
    CommonParameters.authorization()
    CommonParameters.pagination()
    response(200, "OK", Schema.ref(:Stacks))
    response(400, "Client Error")
    response(401, "Unauthorized")
  end

  def index(%Plug.Conn{assigns: %{user_id: user_id}} = conn, args) do
    %{entries: stacks, metadata: page_info} = Stacks.list_stacks(user_id, args)
    render(conn, "index.json", stacks: stacks, page_info: page_info)
  end

  swagger_path :list do
    get("/api/stack/index/{project_id}")
    summary("Query for stacks by project id")
    description("Query for Stacks. This operation supports with paging and filtering")
    produces("application/json")
    tag("Stack")
    operation_id("list_stacks")
    CommonParameters.authorization()

    parameters do
      project_id(:path, :integer, "project ID", required: true)
      type(:query, :string, "type of stack", required: true, enum: ["LOG", "FEEDBACK"])
    end

    response(200, "OK", Schema.ref(:Stacks))
    response(400, "Client Error")
    response(401, "Unauthorized")
  end

  def list(%Plug.Conn{assigns: %{user_id: user_id}} = conn, args) do
    stacks = Stacks.list_stacks(user_id, args)
    render(conn, "index.json", stacks: stacks)
  end

  swagger_path :create do
    post("/api/stack")
    summary("create stack")
    description("Create stack. This operation supports creating")
    produces("application/json")
    tag("Stack")
    operation_id("create_stack")
    CommonParameters.authorization()

    parameters do
      stack(:body, Schema.ref(:CreateStackInput), "stack attributes")
    end

    response(201, "OK", Schema.ref(:Stack))
    response(401, "Unauthorized")
    response(422, "Unprocessable Entity")
  end

  def create(%Plug.Conn{assigns: %{user_id: user_id}} = conn, stack_param) do
    with {:ok, %Stack{} = stack} <- Stacks.create_stack(user_id, stack_param) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.stack_path(conn, :show, stack))
      |> render("show.json", stack: stack)
    end
  end

  swagger_path :show do
    get("/api/stack/{id}")
    summary("Query for Stack")
    description("Query for stack. This operation supports filtering")
    produces("application/json")
    tag("Stack")
    operation_id("get_stack!")
    CommonParameters.authorization()

    parameters do
      id(:path, :integer, "stack ID", required: true)
    end

    response(200, "OK", Schema.ref(:Stack))
    response(400, "Bad Request")
    response(401, "Unauthorized")
    response(404, "Not Found")
  end

  def show(conn, %{"id" => id}) do
    stack = Stacks.get_stack!(id)
    render(conn, "show.json", stack: stack)
  end

  swagger_path :update do
    patch("/api/stack/{id}")
    summary("update stack")
    description("Update stack. This operation supports updating")
    produces("application/json")
    tag("Stack")
    operation_id("update_stack")
    CommonParameters.authorization()

    parameters do
      id(:path, :integer, "stack ID", required: true)
      stack(:body, Schema.ref(:UpdateStackInput), "partial project attributes")
    end

    response(200, "OK", Schema.ref(:Stack))
    response(401, "Unauthorized")
    response(404, "Not Found")
    response(422, "Unprocessable Entity")
  end

  def update(conn, %{"id" => id} = stack_param) do
    stack = Stacks.get_stack!(id)

    with {:ok, %Stack{} = stack} <- Stacks.update_stack(stack, stack_param) do
      render(conn, "show.json", stack: stack)
    end
  end

  swagger_path :remove do
    delete("/api/stack/{stack_id}")
    summary("delete stack")
    description("Delete stack. This operation supports deleting")
    produces("application/json")
    tag("Stack")
    operation_id("delete_stack")
    CommonParameters.authorization()

    parameters do
      id(:path, :string, "stack ID", required: true)
    end

    response(204, "No Content")
    response(400, "Bad Request")
    response(401, "Unauthorized")
    response(404, "Not Found")
  end

  def remove(conn, %{"id" => id}) do
    stack = Stacks.get_stack!(id)

    with {:ok, %Stack{}} <- Stacks.delete_stack(stack) do
      send_resp(conn, :no_content, "")
    end
  end
end
