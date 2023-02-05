defmodule Improoove.Reminder do
  use DynamicSupervisor
  alias Postgrex.Notifications
  alias Improoove.Schedulers.Reminder

  @me ReminderSupervisor

  alias Improoove.Stacks
  def start_link(_) do
    unsent_reminders = Stacks.list_stacks(nil, %{"is_sent" => false})

    unsent_reminders
    |> Enum.reject(&(&1.sent_at < NaiveDateTime.utc_now()))
    |> Enum.map(&Notifications.push_notifications/1)

    unsent_reminders
    |> Enum.filter(&(&1.sent_at < NaiveDateTime.utc_now()))
    |> Enum.map(&Reminder.start_scheduled_task/1)
    |> Enum.map(&DynamicSupervisor.start_child(@me, &1))

    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
