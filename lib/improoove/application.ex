defmodule Improoove.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Improoove.Repo,
      # Start the Telemetry supervisor
      ImproooveWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Improoove.PubSub},
      # Start the Endpoint (http/https)
      ImproooveWeb.Endpoint
      # Start a worker by calling: Improoove.Worker.start_link(arg)
      # {Improoove.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Improoove.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ImproooveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
