defmodule ImproooveWeb.UserView do
  use ImproooveWeb, :view
  alias ImproooveWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      uid: user.uid
    }
  end
end
