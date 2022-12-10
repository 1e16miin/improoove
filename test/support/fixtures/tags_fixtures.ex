defmodule Improoove.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Improoove.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        log_id: 42,
        name: "some name"
      })
      |> Improoove.Tags.create_tag()

    tag
  end
end
