defmodule ImproooveWeb.TagView do
  use ImproooveWeb, :view
  alias ImproooveWeb.TagView

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, TagView, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      log_id: tag.log_id,
      name: tag.name
    }
  end
end
