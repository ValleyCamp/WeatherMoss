defmodule WeatherMossWeb.MeteobridgeTenMinuteAllComponent do
  use WeatherMossWeb, :live_component
  
  def render(assigns) do
    ~L"""
    <h3>Current Data</h3>
    <ul>
      <li>Outside Temperature: <%= @latest.tempOutCur %> &deg;F</li>
      <li>Current Rain Rate: <%= @latest.rainRateCur %> inches/hour</li>
      <li>Rain Daily Total: <%= @latest.rainDay %> inches</li>
      <li><%= @latest.dateTime %><br />(Updates every 10 minutes)</li>
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
