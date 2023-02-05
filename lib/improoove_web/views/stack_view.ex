defmodule ImproooveWeb.StackView do
  use ImproooveWeb, :view
  alias ImproooveWeb.StackView

  def render("index.json", %{stacks: stacks, page_info: page_info}) do
    %{
      data: render_many(stacks, StackView, "stack.json"),
      cursor: page_info.after,
      limit: page_info.limit,
      total_count: page_info.total_count
    }
  end

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
      description: stack.description,
      created_at: stack.created_at,
      type: stack.type
    }
  end
end
