defmodule ImproooveWeb.StackController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Stacks
  alias Improoove.Stacks.Stack

  action_fallback ImproooveWeb.FallbackController

  def swagger_definitions do
    %{
      CreateStackInput:
        swagger_schema do
          title("Create Stack Input")
          description("Create Schema of Log and Feedback")

          properties do
            uid(:string, "The ID of user", required: true)
            project_id(:integer, "ID of project", required: true)
            remind(:integer, "When to send the reminder after create log")
            description(:string, "When was the activity last updated", required: true)
            type(:string, "type of stack", required: true)
          end
        end,
      UpdateStackInput:
        swagger_schema do
          title("Update Stack Input")
          description("Update Schema of Log and Feedback")

          properties do
            remind(:integer, "When to send the reminder after create log")
            description(:string, "When was the activity last updated", required: true)
          end
        end,

      Stack:
        swagger_schema do
          title("Stack")
          description("Stack")

          properties do
            uid(:string, "The ID of user", required: true)
            project_id(:integer, "ID of project", required: true)
            remind(:integer, "When to send the reminder after create log")
            description(:string, "description of stack", required: true)
            type(:string, "type of stack, FEEDBACK | LOG", required: true)
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
    get("/api/stack/index/{uid}")
    summary("Query for stacks")
    description("Query for Stacks. This operation supports with paging and filtering")
    produces("application/json")
    tag("Stack")
    operation_id("list_stacks")
    paging(size: "page_size", offset: "cursor")
    parameters do
      uid(:path, :string, "user ID", required: true)
    end

    response(200, "OK", Schema.ref(:Stacks))
    response(400, "Client Error")
  end

  def index(conn, %{"uid" => uid, "page_size" => page_size, "cursor" => cursor}) do
    stacks = Stacks.list_stacks(uid, page_size, cursor)
    render(conn, "index.json", stacks: stacks)
  end

  swagger_path :create do
    post("/api/stack")
    summary("create stack")
    description("Create stack. This operation supports creating")
    produces("application/json")
    tag("Stack")
    operation_id("create_stack")

    parameters do
      stack(:body, Schema.ref(:CreateStackInput), "stack attributes")
    end

    response(201, "OK", Schema.ref(:Stack))
    response(422, "Validation Error")
  end

  def create(conn, %{"stack" => stack_params}) do
    with {:ok, %Stack{} = stack} <- Stacks.create_stack(stack_params) do
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

    parameters do
      id(:path, :string, "project ID", required: true)
    end

    response(200, "OK", Schema.ref(:Stack))
    response(400, "Bad Request")
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

    parameters do
      id(:path, :integer, "project ID", required: true)
      stack(:body, Schema.ref(:UpdateStackInput), "partial project attributes")
    end

    response(201, "OK", Schema.ref(:Stack))
    response(422, "Validation Error")
  end

  def update(conn, %{"id" => id, "stack" => stack_params} = temp) do
    IO.inspect(temp)
    stack = Stacks.get_stack!(id)

    with {:ok, %Stack{} = stack} <- Stacks.update_stack(stack, stack_params) do
      render(conn, "show.json", stack: stack)
    end
  end

  swagger_path :remove do
    delete("/api/project/{project_id}")
    summary("delete stack")
    description("Delete stack. This operation supports deleting")
    produces("application/json")
    tag("Stack")
    operation_id("delete_stack")

    parameters do
      id(:path, :string, "stack ID", required: true)
    end

    response(200, "OK", Schema.ref(:Stack))
    response(400, "Client Error")
  end

  def remove(conn, %{"id" => id}) do
    stack = %{project_id: project_id} = Stacks.get_stack!(id)

    with {:ok, %Stack{}} <- Stacks.delete_stack(stack) do
      send_resp(conn, :no_content, "")
    end
  end
end
