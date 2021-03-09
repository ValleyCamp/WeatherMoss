defmodule WeatherMossWeb.MeteobridgeTenMinuteAllComponent do
  use WeatherMossWeb, :live_component
  
  def render(assigns) do
    ~L"""
    <div class="flex flex-nowrap">
      <ul class="m-4">
        <li>Outdoor Humidity: <%= @latest.humOutCur %></li>
        <li>Pressure: <%= @latest.pressCur %></li>
        <li>Dewpoint: <%= @latest.dewCur %></li>
        <li>Heat Index: <%= @latest.heatIdxCur %></li>
        <li>Windchill: <%= @latest.windChillCur %></li>
        <li>Avg. UV: <%= @latest.uVAvg10 %></li>
        <li>Max. UV: <%= @latest.uVMax10 %></li>
      </ul>
      <ul class="m-4">
        <li>Avg. Wind Speed: <%= @latest.windAvgSpeedCur %></li>
        <li>Wind Gust: <%= @latest.windGust10 %></li>
        <li>Avg. Wind Direction: <%= @latest.windDirAvg10Eng %></li>
        <li>Indoor Temp: <%= @latest.tempInCur %></li>
        <li>Indoor Humidity: <%= @latest.humInCur %></li>
        <li>Rain - Yesterday: <%= @latest.rainYest %></li>
        <li>Rain - Monthly: <%= @latest.rainMonth %></li>
        <li>Rain - Yearly: <%= @latest.rainYear %></li>
      </ul>
    </div>
    """
  end 

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
