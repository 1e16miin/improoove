defmodule ImproooveWeb.Plugs.Authentication do
  import Plug.Conn

  def init(opts) do
    opts
  end
  def call(conn, :no_args) do
    [authorization] = get_req_header(conn, "authorization")
    {:ok, uid} = Base.decode64(authorization)

    with user <- Improoove.Accounts.get_user_by_uid!(uid) do
      assign(conn, :user_id, user.id)
    else
      _ -> conn |> put_status(:unauthorized)
    end
  end
end
