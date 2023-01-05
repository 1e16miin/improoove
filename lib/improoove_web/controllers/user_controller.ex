defmodule ImproooveWeb.UserController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Accounts
  alias Improoove.Accounts.User

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
end
