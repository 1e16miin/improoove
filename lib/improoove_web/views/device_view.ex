defmodule ImproooveWeb.DeviceView do
  use ImproooveWeb, :view
  alias ImproooveWeb.DeviceView

  def render("show.json", %{device: device}) do
    %{data: render_one(device, DeviceView, "notification.json")}
  end

  def render("device.json", %{device: device}) do
    %{
      os: device.os,
      token: device.token
    }
  end
end
