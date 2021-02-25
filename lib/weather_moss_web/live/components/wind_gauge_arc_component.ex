defmodule WeatherMossWeb.WindGaugeArcComponent do
  use WeatherMossWeb, :live_component

  alias WeatherMossWeb.GaugeArc

  def render(assigns) do
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
    <svg id="<%= @gaugeArc.html_id %>" width="<%= @gaugeArc.svg_width %>" height="<%= @gaugeArc.svg_height %>">
      <g>
        <path d="<%= @gaugeArc.svg_bg_path_string %>" <%= raw(@gaugeArc.raw_bg_svg_style_attr_string) %> />
        <path d="<%= @gaugeArc.svg_fill_path_string %>" <%= raw(@gaugeArc.raw_fill_svg_style_attr_string) %> />
      </g>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="10"  style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">N</text>
      <text text-anchor="middle" x="5"   y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">W</text>
      <text text-anchor="middle" x="245" y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">E</text>
      <g transform="rotate(<%= @gaugeArc.windDirCur %> 125,125)">
        <!--<line x1="125" y1="48" x2="125" y2="210" fill="transparent" stroke="rgba(130, 130, 130, 0.5)" stroke-width="4" stroke-linecap="butt" />-->
        <polygon points="125,38 115,48 135,48" fill="rgba(130, 130, 130, <%= @gaugeArc.windIndicatorTransparency %>)" />
      </g>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="80" style="font-weight: bold; font-size: 1.4rem; opacity: <%= @gaugeArc.windTextTransparency %>;"><%= @gaugeArc.windDirCurEng %></text>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="95" style="font-weight: normal; font-size: 0.7rem; opacity: <%= @gaugeArc.windTextTransparency %>;">(<%= @gaugeArc.windDirCur %>&deg;)</text>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="115" style="font-weight: normal; font-size: 1rem; opacity: <%= @gaugeArc.windTextTransparency %>;">at</text>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="160" style="font-weight: bold; font-size: 3rem;"><%= @gaugeArc.curVal %></text>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="180" style="font-weight: normal; font-size: 1rem;">MPH</text>
      <text text-anchor="middle" x="<%= @gaugeArc.cx %>" y="255" class="gauge_main_label"><%= @gaugeArc.main_label_text %></text>
    </svg>
    """
  end 

end
