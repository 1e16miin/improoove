defmodule ImproooveWeb.ReminderView do
  use ImproooveWeb, :view
  alias ImproooveWeb.ReminderView

  def render("index.json", %{reminders: reminders}) do
    %{data: render_many(reminders, ReminderView, "reminder.json")}
  end

  def render("show.json", %{reminder: reminder}) do
    %{data: render_one(reminder, ReminderView, "reminder.json")}
  end

  def render("reminder.json", %{reminder: reminder}) do
    %{
      id: reminder.id,
      log_id: reminder.log_id,
      is_sent: reminder.is_sent
    }
  end
end
