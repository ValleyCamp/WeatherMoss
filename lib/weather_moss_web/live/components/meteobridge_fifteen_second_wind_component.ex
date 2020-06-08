defmodule WeatherMossWeb.MeteobridgeFifteenSecondWindComponent do
  use WeatherMossWeb, :live_component

  import WeatherMossWeb.ViewHelpers
  import WeatherMossWeb.GaugeHelpers
  alias WeatherMossWeb.GaugeArc

  def render(assigns) do
    wind_transparency = gauge_wind_transparency(assigns.latest.windSpeedCur)

    curWindArc = %GaugeArc{stroke: "#006200", strokeWidth: 14, fillStartPercent: 0, fillEndPercent: 2}
    ~L"""
    <style type="text/css">
      .gauge_fill {
        stroke-dasharray: 200 600;
        animation: gaugeFill 4s ease-in-out;
      }
      @keyframes gaugeFill {
        from {
          stroke-dashoffset: 200;
        }
        to { 
          stroke-dashoffset: 0;
        }
      }
    </style>
    <svg id="svg_fifteenminute_wind" width="250" height="275">
      <g>
        <path d="<%= gauge_arc_path() %>" <%= raw(GaugeArc.raw_svg_style_attr_string()) %> />
        <path d="<%= gauge_arc_path(curWindArc) %>" <%= raw(GaugeArc.raw_svg_style_attr_string(curWindArc)) %> />
      </g>
      <text text-anchor="middle" x="125" y="10"  style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">N</text>
      <text text-anchor="middle" x="5"   y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">W</text>
      <text text-anchor="middle" x="245" y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">E</text>
      <g transform="rotate(<%= @latest.windDirCur %> 125,125)">
        <!--<line x1="125" y1="48" x2="125" y2="210" fill="transparent" stroke="rgba(130, 130, 130, 0.5)" stroke-width="4" stroke-linecap="butt" />-->
        <polygon points="125,38 115,48 135,48" fill="rgba(130, 130, 130, <%= wind_transparency.indicator %>)" />
      </g>
      <text text-anchor="middle" x="125" y="80" style="font-weight: bold; font-size: 2rem; opacity: <%= wind_transparency.text %>;"><%= @latest.windDirCurEng %></text>
      <text text-anchor="middle" x="125" y="95" style="font-weight: normal; font-size: 0.7rem; opacity: <%= wind_transparency.text %>;">(<%= @latest.windDirCur %>&deg;)</text>
      <text text-anchor="middle" x="125" y="115" style="font-weight: normal; font-size: 1rem; opacity: <%= wind_transparency.text %>;">at</text>
      <text text-anchor="middle" x="125" y="160" style="font-weight: bold; font-size: 3rem;"><%= @latest.windSpeedCur %></text>
      <text text-anchor="middle" x="125" y="180" style="font-weight: normal; font-size: 1rem;">MPH</text>
      <text text-anchor="middle" x="125" y="255" class="gauge_main_label">Wind</text>
      <text text-anchor="middle" x="125" y="272" style="font-family: Sans-Serif; font-weight: normal; font-size: 0.6rem;"><%= datetime_format(@latest.dateTime) %></text>
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
