defmodule ImproooveWeb.StackView do
  use ImproooveWeb, :view
  alias ImproooveWeb.StackView

  def render("index.json", %{stacks: stacks}) do
    %{data: render_many(stacks, StackView, "stack.json")}
  end

  def render("show.json", %{stack: stack}) do
    %{data: render_one(stack, StackView, "stack.json")}
  end

  def render("stack.json", %{stack: stack}) do
    %{
      id: stack.id,
      project_id: stack.project_id,
      uid: stack.uid,
      remind: stack.remind,
      description: stack.description,
      created_at: stack.created_at,
      type: stack.type
    }
  end
end
