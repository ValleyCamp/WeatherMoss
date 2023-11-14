defmodule WeatherMossWeb.Support.GaugeLine do
  @moduledoc """
  Data structure representing a vertical line gauge, and providing all the methods needed to calculate rendering of the gauge
  It is assumed these gauges will be vertical, with the scale set from low number at bottom to high number at top. Any re-orientation of that basic assumption must be done via CSS post-rendering.

  GaugeLines are rendered by giving them a coordinate for the top of the line, a line height, and a scaleBottom,scaleTop, which represent the numerical values for the top and bottom of the gauge.
  For example, a temperature gauge might have -20, 75 as it's scale, at which point you set provide your fillBottom,fillTop values as -5,55, and the gague fills appropriately.

  The default GaugeLine is assumed to be rendered in a 150w x 275h viewport, and look correct when rendered next to a GaugeArc
  """

  alias __MODULE__

  defstruct [
    topX: 100.0,
    topY: 25.0,
    height: 185.0,
    scaleTopVal: 100.0,
    scaleBottomVal: 0.0,
    fillTopVal: 100.0,
    fillBottomVal: 0.0,
    bgStroke: "#dddddd",
    bgStrokeWidth: 24,
    fillStroke: "#006200",
    fillStrokeWidth: 14,
    fillStrokeLinecap: "",
    fillStrokeDashoffset: "",
    fillStrokeDasharray: "",
    strokeLinecap: "round",
    curVal: 50.0,
    svg_path_string: "",
    svg_top_marker_path_string: "",
    svg_bottom_marker_path_string: "",
    svg_current_value_marker_path_string: "",
    scale_marker_text_x: 80.0,
    scale_marker_top_text_y: 25.0,
    scale_marker_bottom_text_y: 210.0,
    current_value_text_x: 92.0,
    current_value_text_y: 25.0,
    main_label_text_y: 250.0,
    main_label_text: "Units",
    html_id: "unit_gauge",
    svg_width: 200,
    svg_height: 275,
  ]

  @typedoc"""
  A GaugeLine contains all the details required to build a GaugeLineComponent, including some html/svg specific fields
  that must be calculated/updated if the underlying values change.
  """
  @type t() :: %__MODULE__{
    topX: float,
    topY: float,
    height: float,
    scaleTopVal: float,
    scaleBottomVal: float,
    fillTopVal: float,
    fillBottomVal: float,
    bgStroke: String.t,
    bgStrokeWidth: integer,
    fillStroke: String.t,
    fillStrokeWidth: integer,
    fillStrokeLinecap: String.t,
    fillStrokeDashoffset: String.t,
    fillStrokeDasharray: String.t,
    strokeLinecap: String.t,
    curVal: float,
    svg_path_string: String.t,
    svg_top_marker_path_string: String.t,
    svg_bottom_marker_path_string: String.t,
    svg_current_value_marker_path_string: String.t,
    scale_marker_text_x: float,
    scale_marker_top_text_y: float,
    scale_marker_bottom_text_y: float,
    current_value_text_x: float,
    current_value_text_y: float,
    main_label_text_y: float,
    main_label_text: String.t,
    html_id: String.t,
    svg_width: integer,
    svg_height: integer,
  }


  def populate_from_models(%GaugeLine{} = _line, _latest, _scale_vals) do
    # TODO: Should move the code from build_assigns to here to DRY it up
  end

  @spec build_initial_values(GaugeLine.t()) :: GaugeLine.t()
  def build_initial_values(%GaugeLine{} = line) do
    line
    |> update_svg_path_string()
    |> update_svg_top_marker_path_string()
    |> update_svg_bottom_marker_path_string()
    |> update_scale_marker_text_x()
    |> update_svg_current_value_marker_path_string()
    |> update_current_value_text_x()
    |> update_current_value_text_y()
    |> update_fill_svg_dasharray_attrs()
    |> update_main_label_text_y()
  end

  @spec rebuild_changing_values(GaugeLine.t()) :: GaugeLine.t()
  def rebuild_changing_values(%GaugeLine{} = line) do
    line
    |> update_current_value_text_y()
    |> update_svg_current_value_marker_path_string()
    |> update_fill_svg_dasharray_attrs()
  end

  @spec length_between_scale_values(GaugeLine.t(), float, float) :: float
  def length_between_scale_values(%GaugeLine{scaleTopVal: scaleTop} = _, _, endVal)
    when endVal > scaleTop, do: raise(ArgumentError, message: "Requested ending value above scale range (#{endVal} > #{scaleTop})")
  def length_between_scale_values(%GaugeLine{scaleBottomVal: scaleBottom} = _, _, endVal)
    when endVal < scaleBottom, do: raise(ArgumentError, message: "Requested ending value below scale range (#{endVal} < #{scaleBottom})")
  def length_between_scale_values(%GaugeLine{scaleTopVal: scaleTop} = _, startVal, _)
    when startVal > scaleTop, do: raise(ArgumentError, message: "Requested starting value above scale range (#{startVal} > #{scaleTop})")
  def length_between_scale_values(%GaugeLine{scaleBottomVal: scaleBottom} = _, startVal, _)
    when startVal < scaleBottom, do: raise(ArgumentError, message: "Requested starting value below scale range (#{startVal} < #{scaleBottom})")
  def length_between_scale_values(%GaugeLine{} = line, startScaleVal, endScaleVal) do
    ps = y_for_scale_value(line, startScaleVal)
    pe = y_for_scale_value(line, endScaleVal)

    max(ps, pe) - min(ps, pe)
  end

  @spec y_for_scale_value(GagueLine.t(), float) :: float
  def y_for_scale_value(%GaugeLine{scaleTopVal: scaleTop} = _, scaleVal) 
    when scaleVal > scaleTop, do: raise(ArgumentError, message: "Requested scaleValue outside of scale range. (#{scaleVal} > #{scaleTop})")
  def y_for_scale_value(%GaugeLine{scaleBottomVal: scaleBottom} = _, scaleVal) 
    when scaleVal < scaleBottom, do: raise(ArgumentError, message: "Requested scaleValue outside of scale range. (#{scaleVal} < #{scaleBottom})")
  def y_for_scale_value(%GaugeLine{} = line, scaleVal) do
    gauge_steps = line.height / (line.scaleTopVal - line.scaleBottomVal)
    line.topY + ((line.scaleTopVal - scaleVal) * gauge_steps)
  end


  #####
  # The following update_* methods are designed to take a GaugeLine and rebuild the custom values used for display based
  # on the values that come from the DB model and GaugeLine settings.
  #####

  def update_svg_path_string(%GaugeLine{} = line) do
    # Note that although we store the coords for the GaugeLine based on their top point for the purpose of convenience
    # when thinking about laying multiple of them out on the page, we actually draw the line from the bottom point, for
    # the purpose of stroke-dashoffset and stroke-dasharray
    %{line | svg_path_string: "M#{line.topX} #{line.topY+line.height} V#{line.topY}" }
  end

  def update_svg_top_marker_path_string(%GaugeLine{} = line) do
    %{line | svg_top_marker_path_string: "M#{(line.topX - (line.bgStrokeWidth/2)) + 2} #{line.topY} h-10" }
  end

  def update_svg_bottom_marker_path_string(%GaugeLine{} = line) do
    %{line | svg_bottom_marker_path_string: "M#{(line.topX - (line.bgStrokeWidth / 2)) + 2} #{line.topY + line.height} h-10" }
  end

  def update_scale_marker_text_x(%GaugeLine{} = line) do
    %{line | scale_marker_text_x: (line.topX - (line.bgStrokeWidth / 2)) - 14 }
  end

  def update_svg_current_value_marker_path_string(%GaugeLine{} = line) do
    %{line | svg_current_value_marker_path_string: "M#{(line.topX + ((line.bgStrokeWidth / 2) + 2))} #{y_for_scale_value(line, line.curVal)} h10" }
  end

  def update_current_value_text_x(%GaugeLine{} = line) do
    %{line | current_value_text_x: (line.topX + (line.bgStrokeWidth / 2)) + 14 }
  end

  def update_current_value_text_y(%GaugeLine{} = line) do
    %{line | current_value_text_y: y_for_scale_value(line, line.curVal) }
  end

  def update_main_label_text_y(%GaugeLine{} = line) do
    %{line | main_label_text_y: line.topY + line.height + 45 }
  end

  def update_fill_svg_dasharray_attrs(%GaugeLine{} = line) do
    if line.fillBottomVal == line.scaleBottomVal and line.fillTopVal == line.scaleTopVal do
      line
    else
      prefixLen = length_between_scale_values(line, line.scaleBottomVal, line.fillBottomVal)
      strokeLen = length_between_scale_values(line, line.fillBottomVal, line.fillTopVal)
      %{line | fillStrokeDashoffset: prefixLen, fillStrokeDasharray: "#{strokeLen} #{line.height}" }
    end
  end

end
