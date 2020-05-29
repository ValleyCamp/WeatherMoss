defmodule WeatherMossWeb.MeteobridgeFifteenSecondWindComponent do
  use WeatherMossWeb, :live_component
  
  def render(assigns) do
    ~L"""
    <h3>Current Wind</h3>
    <ul>
      <li>Wind Dir: <%= @latest.windDirCur %>&deg; (<%= @latest.windDirCurEng %>)</li>
      <li>Wind Speed: <%= @latest.windSpeedCur %> miles/hour</li>
      <li><%= @latest.dateTime %><br />(Updates every 15 seconds)</li>
    </ul>
    """
  end 

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
