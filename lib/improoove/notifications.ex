# defmodule Improoove.Notifications do
#   @moduledoc """
#   The Accounts context.
#   """

  import Ecto.Query, warn: false
  alias Improoove.Stacks
  alias Improoove.Repo

#   alias Improoove.Schema.Device

#   @doc """
#   Gets a single user.

#   Raises `Ecto.NoResultsError` if the User does not exist.

#   ## Examples

#       iex> get_user!(123)
#       %User{}

#       iex> get_user!(456)
#       ** (Ecto.NoResultsError)

  """
  def get_devices_by_user_id(user_id) do
    Repo.all(Device, user_id: user_id)
  end

  def push_notifications(user_id, msg) do
    device_tokens =
      get_devices_by_user_id(user_id)
      |> Enum.map(& &1["token"])

    Pigeon.FCM.Notification.new(device_tokens, msg)
  end

#   @doc """
#   Creates a user.

#   ## Examples

#       iex> create_user(%{field: value})
#       {:ok, %User{}}

#       iex> create_user(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

  """
  def create_device(user_id, attrs) do
    %Device{}
    |> Map.put(:user_id, user_id)
    |> IO.inspect()
    |> Device.changeset(attrs)
    |> Repo.insert()
  end
end
