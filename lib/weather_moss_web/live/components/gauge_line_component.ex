defmodule WeatherMossWeb.GaugeLineComponent do
  use WeatherMossWeb, :live_component

  import WeatherMossWeb.ViewHelpers
  alias WeatherMossWeb.GaugeLine
  
  def render(assigns) do
    ~L"""
    <svg id="<%= @gaugeLine.html_id %>" width="<%= @gaugeLine.svg_width %>" height="<%= @gaugeLine.svg_height %>">
      <g>
        <path d="<%= @gaugeLine.svg_path_string %>" <%= raw(@gaugeLine.raw_bg_svg_style_attr_string) %> />
        <path d="<%= @gaugeLine.svg_path_string %>" <%= raw(@gaugeLine.raw_fill_svg_style_attr_string) %> />
        <g>
          <path d="<%= @gaugeLine.svg_top_marker_path_string %>" class="gauge_side_label_marker" />
          <text text-anchor="end" x="<%= @gaugeLine.scale_marker_text_x %>" y="<%= @gaugeLine.scale_marker_top_text_y %>" dominant-baseline="middle" class="gauge_side_label"><%= @gaugeLine.scaleTopVal %></text>
        </g>
        <g>
          <path d="<%= @gaugeLine.svg_bottom_marker_path_string %>" class="gauge_side_label_marker" />
          <text text-anchor="end" x="<%= @gaugeLine.scale_marker_text_x %>" y="<%= @gaugeLine.scale_marker_bottom_text_y %>" dominant-baseline="middle" class="gauge_side_label"><%= @gaugeLine.scaleBottomVal %></text>
        </g>
        <g>
          <path d="<%= @gaugeLine.svg_current_value_marker_path_string %>" class="gauge_side_label_marker" />
          <text text-anchor="start" x="<%= @gaugeLine.current_value_text_x %>" y="<%= @gaugeLine.current_value_text_y %>" dominant-baseline="middle" class="gauge_side_label"><%= @gaugeLine.curVal %></text>
        </g>
        <text text-anchor="middle" x="<%= @gaugeLine.topX %>" y="<%= @gaugeLine.main_label_text_y %>" class="gauge_main_label"><%= @gaugeLine.main_label_text %></text>
      </g>
    </svg>
    """
  end 

end
