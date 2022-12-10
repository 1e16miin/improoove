defmodule CommonParameters do
  @moduledoc "Common parameter declarations for phoenix swagger"

  alias PhoenixSwagger.Path.PathObject
  import PhoenixSwagger.Path

  def authorization(path = %PathObject{}) do
    path |> parameter("Authorization", :header, :string, "uid", required: true)
  end

  def pagination(path = %PathObject{}) do
    path
    |> parameter("cursor", :query, :string, "cursor")
    |> parameter("limit", :query, :integer, "size of page", required: true, default: 10)
  end
end
