defmodule Improoove.RemindersTest do
  use Improoove.DataCase

  alias Improoove.Reminders

  describe "reminders" do
    alias Improoove.Reminders.Reminder

    import Improoove.RemindersFixtures

    @invalid_attrs %{is_sent: nil, log_id: nil}

    test "list_reminders/0 returns all reminders" do
      reminder = reminder_fixture()
      assert Reminders.list_reminders() == [reminder]
    end

    test "get_reminder!/1 returns the reminder with given id" do
      reminder = reminder_fixture()
      assert Reminders.get_reminder!(reminder.id) == reminder
    end

    test "create_reminder/1 with valid data creates a reminder" do
      valid_attrs = %{is_sent: true, log_id: 42}

      assert {:ok, %Reminder{} = reminder} = Reminders.create_reminder(valid_attrs)
      assert reminder.is_sent == true
      assert reminder.log_id == 42
    end

    test "create_reminder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_reminder(@invalid_attrs)
    end

    test "update_reminder/2 with valid data updates the reminder" do
      reminder = reminder_fixture()
      update_attrs = %{is_sent: false, log_id: 43}

      assert {:ok, %Reminder{} = reminder} = Reminders.update_reminder(reminder, update_attrs)
      assert reminder.is_sent == false
      assert reminder.log_id == 43
    end

    test "update_reminder/2 with invalid data returns error changeset" do
      reminder = reminder_fixture()
      assert {:error, %Ecto.Changeset{}} = Reminders.update_reminder(reminder, @invalid_attrs)
      assert reminder == Reminders.get_reminder!(reminder.id)
    end

    test "delete_reminder/1 deletes the reminder" do
      reminder = reminder_fixture()
      assert {:ok, %Reminder{}} = Reminders.delete_reminder(reminder)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_reminder!(reminder.id) end
    end

    test "change_reminder/1 returns a reminder changeset" do
      reminder = reminder_fixture()
      assert %Ecto.Changeset{} = Reminders.change_reminder(reminder)
    end
  end
end
