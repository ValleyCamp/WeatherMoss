defmodule WeatherMossWeb.MeteobridgeFifteenSecondRainAndTempComponent do
  use WeatherMossWeb, :live_component

  import WeatherMossWeb.ViewHelpers
  #import WeatherMossWeb.GaugeHelpers
  alias WeatherMossWeb.GaugeLine
  
  def render(assigns) do
    outsideTempGauge = %GaugeLine{topX: 100, scaleBottomVal: 25, scaleTopVal: 75, fillBottomVal: 50, fillTopVal: 75}
    rainDailyGauge = %GaugeLine{topX: 300, fillBottomVal: 0, fillTopVal: 50}
    ~L"""
    <svg id="svg_fiftenminute_raintemp" width="450" height="275">
      <g>
        <path d="<%= GaugeLine.svg_path_string(outsideTempGauge) %>" <%= raw(GaugeLine.raw_bg_svg_style_attr_string(outsideTempGauge)) %> />
        <path d="<%= GaugeLine.svg_path_string(outsideTempGauge) %>" <%= raw(GaugeLine.raw_fill_svg_style_attr_string(outsideTempGauge)) %> />
        <text text-anchor="middle" x="<%= outsideTempGauge.topX %>" y="<%= GaugeLine.main_label_y(outsideTempGauge) %>" class="gauge_main_label">Temperature</text>
      </g>
      <g>
        <path d="<%= GaugeLine.svg_path_string(rainDailyGauge) %>" <%= raw(GaugeLine.raw_bg_svg_style_attr_string(rainDailyGauge)) %> />
        <path d="<%= GaugeLine.svg_path_string(rainDailyGauge) %>" <%= raw(GaugeLine.raw_fill_svg_style_attr_string(rainDailyGauge)) %> />
        <text text-anchor="middle" x="<%= rainDailyGauge.topX %>" y="<%= GaugeLine.main_label_y(rainDailyGauge) %>" class="gauge_main_label">Rain</text>
      </g>
      <text text-anchor="middle" x="<%= rainDailyGauge.topX %>" y="<%= GaugeLine.main_label_y(outsideTempGauge)+17 %>" style="font-family: Sans-Serif; font-weight: normal; font-size: 1rem;"><%= @latest.rainRateCur %> in/hr</text>
      <text text-anchor="middle" x="225" y="270" style="font-family: Sans-Serif; font-weight: normal; font-size: 0.6rem;"><%= datetime_format(@latest.dateTime) %></text>
    </svg>
    """
  end 

  def mount(socket) do
    {:ok, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
