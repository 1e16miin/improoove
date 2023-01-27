defmodule ImproooveWeb.DeviceController do
  use ImproooveWeb, :controller
  use PhoenixSwagger

  alias Improoove.Notifications
  alias Improoove.Schema.Device

  action_fallback ImproooveWeb.FallbackController

  def swagger_definitions do
    %{
      Device:
        swagger_schema do
          title("Device")
          description("user's mobile device")

          properties do
            os(:string, "device OS", required: true, enum: ["IOS", "ANDROID"])
            token(:string, "device token", require: true)
          end
        end
    }
  end

  swagger_path :create do
    post("/api/device")
    summary("Create user's device information")
    description("")
    produces("application/json")
    tag("Account")
    operation_id("create_device")

    response(201, "OK", Schema.ref(:Device))
  end

  def create(%Plug.Conn{assigns: %{user_id: user_id}} = conn, device_param) do
    with {:ok, %Device{} = device} <- Notifications.create_device(user_id, device_param) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", device: device)
    end
  end
end
