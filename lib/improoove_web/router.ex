defmodule ImproooveWeb.Router do
  use ImproooveWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug PhoenixSwagger.Plug.Validate
  end

  scope "/api", ImproooveWeb do
    pipe_through :api
    get "/project/index/:uid", ProjectController, :index
    get "/project/:id", ProjectController, :show
    post "/project", ProjectController, :create
    patch "/project/:id", ProjectController, :update
    delete "/project/:id", ProjectController, :remove
    get "/stack/index/:uid", StackController, :index
    get "/stack/:id", StackController, :show
    post "/stack", StackController, :create
    patch "/stack/:id", StackController, :update
    delete "/stack/:id", StackController, :remove
  end

  scope "/api/swagger-ui" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :improoove, swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Improoove App"
      }
    }
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ImproooveWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
