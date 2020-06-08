defmodule WeatherMossWeb.GaugeArc do
  @moduledoc """
    Note that all the math in this is designed around the particular gauge arc we're going for.
    It is assumed that the arcs will be the same shap and orientation.
    In fact, changing really anything about the arc size or shape is unsupported. The options are
    really only there for developer ease of understanding and consistency. Good luck to you.
    
    By default a GaugeArc is designed to be rendered inside a 250w x 275h viewport.
  """
  alias __MODULE__

  defstruct [
    cx: 125,
    cy: 125,
    radius: 100,
    startDegree: 120,
    endDegree: 60,
    fill: "transparent",
    stroke: "#dddddd",
    strokeWidth: 24,
    strokeLinecap: "round",
    fillStartPercent: 0,
    fillEndPercent: 100,
  ]
  
  def raw_svg_style_attr_string() do
    raw_svg_style_attr_string(%GaugeArc{})
  end

  def raw_svg_style_attr_string(%GaugeArc{} = arc) do
    "fill=\"#{arc.fill}\" stroke=\"#{arc.stroke}\" stroke-width=\"#{arc.strokeWidth}\" stroke-linecap=\"#{arc.strokeLinecap}\"#{raw_svg_dasharray_attr_string(arc)}"
  end

  def raw_svg_dasharray_attr_string(%GaugeArc{} = arc) do
    if arc.fillStartPercent == 0 and arc.fillEndPercent == 100 do
      ""
    else
      prefixLen = length_between_percents_of_gauge(arc, 0, arc.fillStartPercent)
      strokeLen = length_between_percents_of_gauge(arc, arc.fillStartPercent, arc.fillEndPercent)
      suffixLen = length_between_percents_of_gauge(arc, 0, 100) # Ensure there is always sufficent gap. We don't want the 2nd number of the dasharray to be zero, in case of fill 50-100%, for example
      " stroke-dashoffset=\"-#{prefixLen}\" stroke-dasharray=\"#{strokeLen} #{suffixLen}\""
    end
  end

  # Gauges are going to be semi-circles or greater, so we always want the larger interior angle
  def interior_angle_of_gauge(%GaugeArc{} = arc) do
    interior_major_angle(arc.startDegree, arc.endDegree)
  end

  def degree_for_percent_of_gauge(%GaugeArc{} = arc, percent) do
    step_angle = interior_angle_of_gauge(arc)/100
    final_degree = arc.startDegree + (step_angle * percent)
    if final_degree > 360, do: final_degree - 360, else: final_degree
  end

  def point_for_percent_of_gauge(%GaugeArc{} = arc, percent) do
    point_at_degree(arc, degree_for_percent_of_gauge(arc, percent))
  end

  def point_at_degree(%GaugeArc{} = arc, theta_degrees) do
    %{x: arc.radius*:math.cos(theta_degrees * :math.pi / 180)+arc.cx, y: arc.radius*:math.sin(theta_degrees * :math.pi / 180)+arc.cy}
  end

  def length_along_arc(%GaugeArc{} = arc, interior_angle) do
    (2 * :math.pi * arc.radius) * (interior_angle/360)
  end

  def length_between_percents_of_gauge(%GaugeArc{startDegree: gsd, endDegree: ged} = arc, start_percent, end_percent) do
    # This only works with the default gauge, or some other gauge where arc.gaugeStart > arc.gaugeEnd
    # Because of this we'll fail immediately if someone is, for some demented reason, trying to use this method in the unsupported case
    if ged > gsd, do: raise(ArgumentError, message: "Not a supported arc orientation, read the comments.")

    # Calculate the length between, ensuring that we're following along the painted arc, by doing the following:
    # 1) get start and end degrees for given percents
    # 2) move start and end degrees equally so that the start degree lines up with the arc's start degree (0%) 
    #    Note: in practice we only need to move the end degree, we can calculate the length using the non-offset degrees once we know which arc to use
    # 3) determine if the end degree for the given percent is greater than 180 degrees from the start arc, or less than the end arc
    #    Note: Remember that our arc starts at 120, wraps past zero, and goes to 60
    # 4) If step 3 returned true, we want the major arc distance between the start/end degrees for the percents, else we want the minor arc distance
    fill_start_degree = degree_for_percent_of_gauge(arc, start_percent)
    fill_end_degree = degree_for_percent_of_gauge(arc, end_percent)

    # Handle the possibility of the the degree opposite start being > 0-degree, and thus needing wrapping to get actual degree
    # Although we're really only aiming at supporting the 120-60 degree gauge.
    degree_opposite_gauge_start = case gsd+180 do
      od when od > 360  -> od - 360
      od                -> od
    end

    # Get the number of degrees to rotate the percentage arc to line it up with the gauge starte
    # < arc.StartDegree implies in the gauge segment between 0 degrees and arc.endDegree, so our "current" degree is 360+ the actua degree
    offset_degrees = case fill_start_degree do
      sd when sd >= gsd   -> fill_start_degree - gsd
      sd when sd < gsd    -> (360 + fill_start_degree) - gsd
    end

    # Get the degree for the end of the percentage arc, after rotating by the correct offset amount
    # <= arg.endDegree implies that the end degree is in the segment between 0 degrees and arc.endDegree, so we have to wrap back
    offset_end = case fill_end_degree do
      ed when ed <= ged   -> (360 + fill_end_degree) - offset_degrees
      _                   -> fill_end_degree - offset_degrees
    end

    # Now we're ready to actually do the comparison and see if we're going to give back a major or minor arc
    #IO.inspect("#{start_percent} to #{end_percent}: Offset to align with start: #{offset_degrees}, End after moving offest: #{offset_end}, Degree opposite gauge start (#{gsd}): #{degree_opposite_gauge_start}")
    if offset_end > degree_opposite_gauge_start or offset_end <= ged do
      length_along_arc(arc, interior_major_angle(fill_start_degree, fill_end_degree))
    else
      length_along_arc(arc, interior_minor_angle(fill_start_degree, fill_end_degree))
    end
  end

  def interior_major_angle(a1, a2) do
    d = abs(a1 - a2)
    if d < 180 do
      360 - d
    else
      d
    end
  end

  def interior_minor_angle(a1, a2) do
    d = abs(a1 - a2)
    if d > 180 do
      360 - d
    else
      d
    end
  end

end

defmodule WeatherMossWeb.GaugeLine do
  @moduledoc """
  Data structure representing a vertical line gauge, and providing all the methods needed to calculate rendering of the gauge
  It is assumed these gauges will be vertical, with the scale set from low number at bottom to high number at top. Any re-orientation of that basic assumption must be done via CSS post-rendering.

  GaugeLines are rendered by giving them a coordinate for the top of the line, a line height, and a scaleBottom,scaleTop, which represent the numerical values for the top and bottom of the gauge.
  For example, a temperature gauge might have -20, 75 as it's scale, at which point you set provide your fillBottom,fillTop values as -5,55, and the gague fills appropriately.

  The default GaugeLine is assumed to be rendered in a 150w x 275h viewport, and look correct when rendered next to a GaugeArc
  """

  alias __MODULE__

  defstruct [
    topX: 75,
    topY: 25,
    height: 185,
    scaleTopVal: 100,
    scaleBottomVal: 0,
    fillTopVal: 100,
    fillBottomVal: 0,
    bgStroke: "#dddddd",
    bgStrokeWidth: 24,
    fillStroke: "#006200",
    fillStrokeWidth: 14,
    strokeLinecap: "round",

  ]

  def svg_path_string(%GaugeLine{} = line) do
    # Note that although we store the coords for the GaugeLine based on their top point for the purpose of convenience
    # when thinking about laying multiple of them out on the page, we actually draw the line from the bottom point, for
    # the purpose of stroke-dashoffset and stroke-dasharray
    "M#{line.topX} #{line.topY+line.height} V#{line.topY}"
  end

  def raw_bg_svg_style_attr_string(%GaugeLine{} = line) do
    "fill=\"transparent\" stroke=\"#{line.bgStroke}\" stroke-width=\"#{line.bgStrokeWidth}\" stroke-linecap=\"#{line.strokeLinecap}\""
  end

  def raw_fill_svg_style_attr_string(%GaugeLine{} = line) do
    "fill=\"transparent\" stroke=\"#{line.fillStroke}\" stroke-width=\"#{line.fillStrokeWidth}\" stroke-linecap=\"#{line.strokeLinecap}\"#{raw_svg_dasharray_attr_string(line)}"
  end

  def raw_svg_dasharray_attr_string(%GaugeLine{} = line) do
    if line.fillBottomVal == line.scaleBottomVal and line.fillTopVal == line.scaleTopVal do
      ""
    else
      prefixLen = length_between_scale_values(line, line.scaleBottomVal, line.fillBottomVal)
      strokeLen = length_between_scale_values(line, line.fillBottomVal, line.fillTopVal)
      " stroke-dashoffset=\"-#{prefixLen}\" stroke-dasharray=\"#{strokeLen} #{line.height}\""
    end
  end

  def length_between_scale_values(%GaugeLine{scaleTopVal: scaleTop} = _, _, endVal)
    when endVal > scaleTop, do: raise ArgumentError, message: "Requested ending value above scale range (#{endVal} > #{scaleTop})"
  def length_between_scale_values(%GaugeLine{scaleBottomVal: scaleBottom} = _, _, endVal)
    when endVal < scaleBottom, do: raise ArgumentError, message: "Requested ending value below scale range (#{endVal} < #{scaleBottom})"
  def length_between_scale_values(%GaugeLine{scaleTopVal: scaleTop} = _, startVal, _)
    when startVal > scaleTop, do: raise ArgumentError, message: "Requested starting value above scale range (#{startVal} > #{scaleTop})"
  def length_between_scale_values(%GaugeLine{scaleBottomVal: scaleBottom} = _, startVal, _)
    when startVal < scaleBottom, do: raise ArgumentError, message: "Requested starting value below scale range (#{startVal} < #{scaleBottom})"
  def length_between_scale_values(%GaugeLine{} = line, startScaleVal, endScaleVal) do
    ps = y_for_scale_value(line, startScaleVal)
    pe = y_for_scale_value(line, endScaleVal)

    max(ps, pe) - min(ps, pe)
  end

  def y_for_scale_value(%GaugeLine{scaleTopVal: scaleTop} = _, scaleVal) 
    when scaleVal > scaleTop, do: raise ArgumentError, message: "Requested scaleValue outside of scale range. (#{scaleVal} > #{scaleTop})"
  def y_for_scale_value(%GaugeLine{scaleBottomVal: scaleBottom} = _, scaleVal) 
    when scaleVal < scaleBottom, do: raise ArgumentError, message: "Requested scaleValue outside of scale range. (#{scaleVal} < #{scaleBottom})"
  def y_for_scale_value(%GaugeLine{} = line, scaleVal) do
    gauge_steps = line.height / (line.scaleTopVal - line.scaleBottomVal)
    line.topY + ((line.scaleTopVal - scaleVal) * gauge_steps)
  end

  # The main label under the gauge should be offset enough to match up with the height of a GaugeArc 
  def main_label_y(%GaugeLine{} = line) do
    line.topY + line.height + 45
  end

end

defmodule WeatherMossWeb.GaugeHelpers do
  @moduledoc """
  Commond methods used to generate the weather gauges
  """
  
  use Phoenix.HTML
  alias WeatherMossWeb.GaugeArc
  #alias WeatherMossWeb.GaugeLine

  def gauge_arc_path(arc \\ %GaugeArc{}) do
    startpoint = GaugeArc.point_at_degree(arc, arc.startDegree)
    endpoint = GaugeArc.point_at_degree(arc, arc.endDegree)
    large_arc = 1 #if arc.endDegree - arc.startDegree > 180, do: 1, else: 0
    sweep = 1
    "M#{startpoint.x} #{startpoint.y} A#{arc.radius},#{arc.radius} 0 #{large_arc},#{sweep} #{endpoint.x},#{endpoint.y}" 
  end

  def gauge_wind_transparency(windspeed) do
    case Decimal.to_float(windspeed) do
      s when s > 3.0 -> %{text: 1.0, indicator: 1.0}
      s when s > 1.0 -> %{text: 1.0, indicator: 0.5}
      s when s > 0.1 -> %{text: 0.7, indicator: 0.3}
      _              -> %{text: 0.2, indicator: 0.15}
    end
  end

end
