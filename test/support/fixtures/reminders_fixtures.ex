defmodule Improoove.RemindersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Improoove.Reminders` context.
  """

  @doc """
  Generate a reminder.
  """
  def reminder_fixture(attrs \\ %{}) do
    {:ok, reminder} =
      attrs
      |> Enum.into(%{
        is_sent: true,
        log_id: 42
      })
      |> Improoove.Reminders.create_reminder()

    reminder
  end
end
