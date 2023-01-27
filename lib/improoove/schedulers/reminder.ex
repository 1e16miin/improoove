defmodule Improoove.Schedulers.Reminder do
  alias Improoove.Schema.Stack
  alias Improoove.{Notifications, Projects, Stacks}

  def get_scheduled_item(id) do
    # ie. "scheduled-task-1"
    list = Registry.lookup(RegistryName, id)

    if length(list) > 0 do
      {pid, _} = hd(list)
      {:ok, pid}
    else
      {:error, "does not exist"}
    end
  end

  def cancel_scheduled_item(sup, id) do
    with {:ok, pid} <- get_scheduled_item(id) do
      DynamicSupervisor.terminate_child(sup, pid)
    end
  end

  def start_scheduled_task(sup, scheduled_task) do
    child =
      scheduled_task
      |> child_spec_for_scheduled_task

    DynamicSupervisor.start_child(sup, child)
  end

  defp child_spec_for_scheduled_task(%Stack{id: id, sent_at: sent_at} = task) do
    %{id: "reminder-stack-#{id}", start: {SchedEx, :run_at, mfa_for_task(task) ++ [sent_at]}}
  end

  defp mfa_for_task(%{user_id: user_id, project_id: project_id} = stack) do
    # Logic that returns the [m, f, a] that should be invoked when task comes due
    %{name: project_name} = Projects.get_project!(project_id)
    Notifications.push_notifications(user_id, %{"body" => "#{project_name}의 리마인더가 도착했어요."})
    Stacks.update_stack(stack, %{is_sent: true})
  end
end
