# defmodule Improoove.Notifications do
#   @moduledoc """
#   The Accounts context.
#   """

#   import Ecto.Query, warn: false
#   alias Improoove.Repo

#   alias Improoove.Schema.Device

#   @doc """
#   Gets a single user.

#   Raises `Ecto.NoResultsError` if the User does not exist.

#   ## Examples

#       iex> get_user!(123)
#       %User{}

#       iex> get_user!(456)
#       ** (Ecto.NoResultsError)

#   """
#   def get_devices_by_user_id(user_id) do
#     Repo.all(Device, user_id: user_id)
#   end

#   @doc """
#   Creates a user.

#   ## Examples

#       iex> create_user(%{field: value})
#       {:ok, %User{}}

#       iex> create_user(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def create_device(attrs) do
#     %Device{}
#     |> Device.changeset(attrs)
#     |> Repo.insert()
#   end
# end
