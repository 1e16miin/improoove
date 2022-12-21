defmodule Improoove.Endpoint do
  use Phoenix.Endpoint, otp_app: :improoove

  plug CORSPlug

  plug Improoove.Router
end
