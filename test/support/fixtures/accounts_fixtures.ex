defmodule Improoove.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Improoove.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        uid: "some uid"
      })
      |> Improoove.Accounts.create_user()

    user
  end
end
