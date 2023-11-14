defmodule WeatherMossWeb.WidgetComponents do
  @moduledoc """
  Provides SVG Gauge components.

  ## Usage
  These components will require an appropriate struct
  of GaugeLine or GaugeArc to be passed in as an assign.

  ```elixir
  <.gaugeLine id="fifteen_second_temperature_gauge" gaugeLine={@fifteen_second_temperature_gauge} />
  '''
  """
  use Phoenix.Component
  #import WeatherMossWeb.Gettext
  #alias Phoenix.LiveView.JS
  alias WeatherMossWeb.Support.{GaugeLine,GaugeArc}

  attr :gaugeLine, GaugeLine, required: true
  def gaugeLine(assigns) do
    ~H"""
    <svg id={ @gaugeLine.html_id } width={ @gaugeLine.svg_width } height={ @gaugeLine.svg_height }>
      <g>
        <path
          d={ @gaugeLine.svg_path_string }
          fill="transparent"
          stroke={ @gaugeLine.bgStroke }
          stroke-width={ @gaugeLine.bgStrokeWidth }
          stroke-linecap={ @gaugeLine.strokeLinecap }
        />
        <path
          d={ @gaugeLine.svg_path_string }
          fill="transparent"
          stroke={ @gaugeLine.fillStroke }
          stroke-width={ @gaugeLine.fillStrokeWidth }
          stroke-linecap={ @gaugeLine.fillStrokeLinecap }
          stroke-dashoffset={ @gaugeLine.fillStrokeDashoffset }
          stroke-dasharray={ @gaugeLine.fillStrokeDasharray }
        />
        <g>
          <path d={ @gaugeLine.svg_top_marker_path_string } class="gauge_side_label_marker" />
          <text
            text-anchor="end"
            x={ @gaugeLine.scale_marker_text_x }
            y={ @gaugeLine.scale_marker_top_text_y }
            dominant-baseline="middle"
            class="gauge_side_label"
          >
            <%= @gaugeLine.scaleTopVal %>
          </text>
        </g>
        <g>
          <path d={ @gaugeLine.svg_bottom_marker_path_string } class="gauge_side_label_marker" />
          <text text-anchor="end" x={ @gaugeLine.scale_marker_text_x } y={ @gaugeLine.scale_marker_bottom_text_y } dominant-baseline="middle" class="gauge_side_label"><%= @gaugeLine.scaleBottomVal %></text>
        </g>
        <g>
          <path d={ @gaugeLine.svg_current_value_marker_path_string } class="gauge_side_label_marker" />
          <text text-anchor="start" x={ @gaugeLine.current_value_text_x } y={ @gaugeLine.current_value_text_y } dominant-baseline="middle" class="gauge_side_label"><%= @gaugeLine.curVal %></text>
        </g>
        <text text-anchor="middle" x={ @gaugeLine.topX } y={ @gaugeLine.main_label_text_y } class="gauge_main_label"><%= @gaugeLine.main_label_text %></text>
      </g>
    </svg>
    """
  end 


  # TODO: The CSS should be inserted once onto the page, rather than
  #       repeated for each gaugeArc that's put onto the page...
  #       Not sure how to do that *just* be calling the GaugeArc though.
  #       Maybe a separate component that just does the CSS?
  attr :gaugeArc, GaugeArc, required: true
  def gaugeArc(assigns) do
    ~H"""
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
    <svg id={ @gaugeArc.html_id } width={ @gaugeArc.svg_width } height={ @gaugeArc.svg_height }>
      <g>
        <path
          d={ @gaugeArc.svg_bg_path_string }
          fill={ @gaugeArc.bgFill }
          stroke={ @gaugeArc.bgStroke }
          stroke-width={ @gaugeArc.bgStrokeWidth }
          stroke-linecap={ @gaugeArc.bgStrokeLinecap }
        />
        <path
          d={ @gaugeArc.svg_fill_path_string }
          fill="transparent"
          stroke={ @gaugeArc.fillStroke }
          stroke-width={ @gaugeArc.fillStrokeWidth }
          stroke-linecap={ @gaugeArc.fillStrokeLinecap }
          stroke-dashoffset={ @gaugeArc.fillStrokeDashoffset }
          stroke-dasharray={ @gaugeArc.fillStrokeDasharray }
        />
      </g>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="10"  style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">N</text>
      <text text-anchor="middle" x="5"   y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">W</text>
      <text text-anchor="middle" x="245" y="125" style="font-family: Sans-Serif; font-weight: bold; font-size: 10px;">E</text>
      <g transform={ "rotate(#{@gaugeArc.windDirCur} 125,125)" }>
        <!--<line x1="125" y1="48" x2="125" y2="210" fill="transparent" stroke="rgba(130, 130, 130, 0.5)" stroke-width="4" stroke-linecap="butt" />-->
        <polygon points="125,38 115,48 135,48" fill={ "rgba(130, 130, 130, #{@gaugeArc.windIndicatorTransparency})" } />
      </g>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="80" style={ "font-weight: bold; font-size: 1.4rem; opacity: #{@gaugeArc.windTextTransparency};" }><%= @gaugeArc.windDirCurEng %></text>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="95" style={ "font-weight: normal; font-size: 0.7rem; opacity: #{@gaugeArc.windTextTransparency};" }>(<%= @gaugeArc.windDirCur %>&deg;)</text>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="115" style={ "font-weight: normal; font-size: 1rem; opacity: #{@gaugeArc.windTextTransparency} %>;" }>at</text>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="160" style="font-weight: bold; font-size: 3rem;"><%= @gaugeArc.curVal %></text>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="180" style="font-weight: normal; font-size: 1rem;">MPH</text>
      <text text-anchor="middle" x={ @gaugeArc.cx } y="255" class="gauge_main_label"><%= @gaugeArc.main_label_text %></text>
    </svg>
    """
  end 


  attr :data, :map, required: true
  def meteobridgeTenMinuteAll(assigns) do
    ~H"""
    <div class="flex flex-nowrap">
      <ul class="m-4">
        <li>Outdoor Humidity: <%= @data.humOutCur %></li>
        <li>Pressure: <%= @data.pressCur %></li>
        <li>Dewpoint: <%= @data.dewCur %></li>
        <li>Heat Index: <%= @data.heatIdxCur %></li>
        <li>Windchill: <%= @data.windChillCur %></li>
        <li>Avg. UV: <%= @data.uVAvg10 %></li>
        <li>Max. UV: <%= @data.uVMax10 %></li>
      </ul>
      <ul class="m-4">
        <li>Avg. Wind Speed: <%= @data.windAvgSpeedCur %></li>
        <li>Wind Gust: <%= @data.windGust10 %></li>
        <li>Avg. Wind Direction: <%= @data.windDirAvg10Eng %></li>
        <li>Indoor Temp: <%= @data.tempInCur %></li>
        <li>Indoor Humidity: <%= @data.humInCur %></li>
        <li>Rain - Yesterday: <%= @data.rainYest %></li>
        <li>Rain - Monthly: <%= @data.rainMonth %></li>
        <li>Rain - Yearly: <%= @data.rainYear %></li>
      </ul>
    </div>
    """
  end 
end
