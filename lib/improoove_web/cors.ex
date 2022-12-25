defmodule ImproooveWeb.CORS do
  use Corsica.Router,
    origins: ["http://localhost", "http://3.37.83.68"],
    allow_credentials: true,
    max_age: 600

  resource "/swagger-ui/*", origins: "*"
  resource "/*"
end
