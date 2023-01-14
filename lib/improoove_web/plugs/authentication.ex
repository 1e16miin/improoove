defmodule ImproooveWeb.Plugs.Authentication do
  alias Improoove.Accounts.User
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, :no_args) do
    [authorization] = get_req_header(conn, "authorization")

    with {:ok, uid} <- Base.decode64(authorization),
         %User{} = user <- Improoove.Accounts.get_user_by_uid(uid) do
      assign(conn, :user_id, user.id)
    else
      _ ->
        conn
        |> IO.inspect()
        |> put_req_header("www-authenticate", authorization)
        |> resp(401, "Unauthorized")
        |> halt()
    end
  end
end
