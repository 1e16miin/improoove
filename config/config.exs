# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :improoove,
  ecto_repos: [Improoove.Repo],
  generators: [id: true]

config :improoove, Improoove.Repo,
  priv: "priv/repo",
  migration_timestamps: [type: :utc_datetime, inserted_at: :created_at]

# Configures the endpoint
config :improoove, ImproooveWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ImproooveWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Improoove.PubSub,
  live_view: [signing_salt: "hTTtalSr"]

config :improoove, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: ImproooveWeb.Router,
      endpoint: ImproooveWeb.Endpoint
    ]
  }

config :improoove, Improoove.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg|json)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/your_app_web/views/.*(ex)$},
      ~r{lib/your_app_web/controllers/.*(ex)$},
      ~r{lib/your_app_web/templates/.*(eex)$}
    ]
  ],
  reloadable_compilers: [:gettext, :phoenix, :elixir, :phoenix_swagger]

config :ex_json_schema,
       :remote_schema_resolver,
       fn url -> HTTPoison.get!(url).body |> Poison.decode!() end

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :improoove, Improoove.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason
config :phoenix_swagger, json_library: Jason
config :phoenix, :format_encoders, json: Casex.CamelCaseEncoder

config :fcmex,
  server_key: "BNHj6pSMfHuyBRyWCEpAUSNFiKqYXveg7K6leo9s0TZIOXvyHUF0BK1Qy2WigIB6ftho_DT7FX1rCOc3RK00FFM"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
