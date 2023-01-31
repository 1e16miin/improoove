defmodule ImproooveWeb.UserController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Accounts
  alias Improoove.Schema.User

  action_fallback ImproooveWeb.FallbackController

  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("User")

          properties do
            uid(:string, "uid", required: true)
          end
        end
    }
  end

  swagger_path :create do
    post("/api/account")
    summary("create account")
    description("Create account. This operation supports creating")
    produces("application/json")
    tag("Account")
    operation_id("create_account")

    response(201, "OK", Schema.ref(:User))
  end

  def create(conn, _) do
    with {:ok, %User{} = user} <- Accounts.create_user() do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  swagger_path :show do
    get("/api/account/{uid}")
    summary("Query for Account")
    description("Query for Account. This operation supports filtering")
    produces("application/json")
    tag("Account")
    operation_id("get_user_by_uid")

    parameters do
      uid(:path, :string, "encoded user id", required: true)
    end

    response(200, "OK", Schema.ref(:User))
    response(401, "Unauthorized")
  end

  def show(conn, %{"uid" => uid}) do
    with {:ok, uid} <- Base.decode64(uid), %User{} = user <- Accounts.get_user_by_uid(uid) do
      render(conn, "show.json", user: user)
    else
      _ ->
        conn
        |> put_req_header("www-authenticate", uid)
        |> resp(401, "Unauthorized")
        |> halt()
    end
  end
end
