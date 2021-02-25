defmodule WeatherMossWeb.GagueArcTest do
  alias WeatherMossWeb.GaugeArc
  alias WeatherMossWeb.GaugeLine

  use ExUnit.Case
 # doctest GaugeArc


  # TODO: Should have more params tested? Should even exist?
  test "default parameters are correct" do
    ga = %GaugeArc{}

    assert ga.startDegree == 120
    assert ga.endDegree == 60
  end

  test "interior angle calculated correctly for default gauge" do
    ga = %GaugeArc{}

    assert GaugeArc.interior_angle_of_gauge(ga) == 300
  end

  test "interior angle calculates major angle between degrees" do
    ga = %GaugeArc{startDegree: 270, endDegree: 330}
    assert GaugeArc.interior_angle_of_gauge(ga) == 300
  end

  test "degree for percent of gauge calculated correctly" do
    ga = %GaugeArc{}

    # Check known angles for the default arc
    assert GaugeArc.degree_for_percent_of_gauge(ga, 0) == 120
    assert GaugeArc.degree_for_percent_of_gauge(ga, 100) == 60
    assert GaugeArc.degree_for_percent_of_gauge(ga, 50) == 270
  end

  test "point for percent of gauge calculated correctly" do
    ga = %GaugeArc{}

    # Check known points for default arc, taking into account decimal precision
    %{x: xs, y: ys} = GaugeArc.point_for_percent_of_gauge(ga, 0)
    assert_in_delta xs, 75, 0.01
    assert_in_delta ys, 211.6, 0.01
    %{x: xm, y: ym} = GaugeArc.point_for_percent_of_gauge(ga, 50)
    assert_in_delta xm, 125, 0.01
    assert_in_delta ym, 25, 0.01
    %{x: xe, y: ye} = GaugeArc.point_for_percent_of_gauge(ga, 100)
    assert_in_delta xe, 175, 0.01
    assert_in_delta ye, 211.6, 0.01
  end

  test "point at degree calculated correctly" do
    ga = %GaugeArc{}

    # Check known points for default arc, taking into account decimal precision
    %{x: xs, y: ys} = GaugeArc.point_at_degree(ga, 120)
    assert_in_delta xs, 75, 0.01
    assert_in_delta ys, 211.6, 0.01
    %{x: xl, y: yl} = GaugeArc.point_at_degree(ga, 180)
    assert_in_delta xl, 25, 0.01
    assert_in_delta yl, 125, 0.01
    %{x: xm, y: ym} = GaugeArc.point_at_degree(ga, 270)
    assert_in_delta xm, 125, 0.01
    assert_in_delta ym, 25, 0.01
    %{x: xr, y: yr} = GaugeArc.point_at_degree(ga, 0)
    assert_in_delta xr, 225, 0.01
    assert_in_delta yr, 125, 0.01
    %{x: xe, y: ye} = GaugeArc.point_at_degree(ga, 60)
    assert_in_delta xe, 175, 0.01
    assert_in_delta ye, 211.6, 0.01
  end

  test "length along arc calculated correcty" do
    ga = %GaugeArc{}

    # Check known values for the default arc
    assert_in_delta GaugeArc.length_along_arc(ga, 180), 314.159, 0.01
    assert_in_delta GaugeArc.length_along_arc(ga, 90), 157.0796, 0.01
    assert_in_delta GaugeArc.length_along_arc(ga, 300), 523.599, 0.01
  end

  test "length between percents of gauge calculated correctly" do
    ga = %GaugeArc{}

    # Ensure error is raised in the unsupported case of gauge orientation not being roughly the same as the 120-to-60-degree vertically oriented gauge.
    bga = %GaugeArc{startDegree: 181, endDegree: 359}
    assert_raise ArgumentError, ~r/^Not a supported arc orientation/, fn ->
      GaugeArc.length_between_percents_of_gauge(bga, 0, 100)
    end

    # Check known values for the default arc
    assert_in_delta GaugeArc.length_between_percents_of_gauge(ga, 0, 100), 523.599, 0.01
    assert_in_delta GaugeArc.length_between_percents_of_gauge(ga, 0, 10), 52.359, 0.01
    # Check the 10% value at various places around the arc in order to make sure we handle wrapping past 0-degrees
    assert_in_delta GaugeArc.length_between_percents_of_gauge(ga, 45, 55), 52.359, 0.01
    assert_in_delta GaugeArc.length_between_percents_of_gauge(ga, 75, 85), 52.359, 0.01
    assert_in_delta GaugeArc.length_between_percents_of_gauge(ga, 90, 100), 52.359, 0.01
  end


  test "interior major angle calculated correctly" do
    assert GaugeArc.interior_major_angle(0, 180) == 180
    assert GaugeArc.interior_major_angle(0, 90) == 270
    assert GaugeArc.interior_major_angle(0, 270) == 270
    assert GaugeArc.interior_major_angle(350, 10) == 340
    assert GaugeArc.interior_major_angle(10, 350) == 340
  end

  test "interior minor angle calculated correctly " do
    assert GaugeArc.interior_minor_angle(0, 180) == 180
    assert GaugeArc.interior_minor_angle(0, 90) == 90
    assert GaugeArc.interior_minor_angle(0, 270) == 90
    assert GaugeArc.interior_minor_angle(350, 10) == 20 
    assert GaugeArc.interior_minor_angle(10, 350) == 20
  end

  test "raw SVG style attr string is generated correctly" do

  end

  test "raw SVG dasharray attr string is generated correctly for default values" do

  end

  test "raw SVG dasharray attr string is generated correctly for arbitrary fill percentage from 0-50" do

  end

  test "x value for scale value is calculated correctly" do
    # Compare to calculated known values for arbitrary line
    line1 = %GaugeLine{scaleTopVal: 100, scaleBottomVal: 0, fillTopVal: 100, fillBottomVal: 0, topX: 10, topY: 25, height: 100}
    assert GaugeLine.y_for_scale_value(line1, 100) == 25 
    assert GaugeLine.y_for_scale_value(line1, 75) == 50
    assert GaugeLine.y_for_scale_value(line1, 50) == 75
    assert GaugeLine.y_for_scale_value(line1, 25) == 100
    assert GaugeLine.y_for_scale_value(line1, 0) == 125

    # Compare to calculated known values for arbitrary line
    line2 = %GaugeLine{scaleTopVal: 80, scaleBottomVal: 20, fillTopVal: 80, fillBottomVal: 20, topX: 10, topY: 25, height: 100}
    assert GaugeLine.y_for_scale_value(line2, 80) == 25 
    assert GaugeLine.y_for_scale_value(line2, 65) == 50
    assert GaugeLine.y_for_scale_value(line2, 50) == 75
    assert GaugeLine.y_for_scale_value(line2, 35) == 100
    assert GaugeLine.y_for_scale_value(line2, 20) == 125
  end

  test "x value for scale correctly throws error if given a scaleValue outside the gauge range" do
    line = %GaugeLine{scaleTopVal: 90, scaleBottomVal: 10}
    assert_raise ArgumentError, ~r/^Requested scaleValue outside of scale range/, fn ->
      GaugeLine.y_for_scale_value(line, 9.999)
    end
    assert_raise ArgumentError, ~r/^Requested scaleValue outside of scale range/, fn ->
      GaugeLine.y_for_scale_value(line, 90.001)
    end
  end

  test "length_between_scale_value throws error if requested values outside of scale" do
    line = %GaugeLine{scaleTopVal: 90, scaleBottomVal: 10}
    # Start val below gauge scale
    assert_raise ArgumentError, ~r/^Requested starting value below scale range/, fn ->
      GaugeLine.length_between_scale_values(line, 0, 50)
    end
    # start val above gauge end
    assert_raise ArgumentError, ~r/^Requested starting value above scale range/, fn ->
      GaugeLine.length_between_scale_values(line, 100, 50)
    end
    # End val below gauge start
    assert_raise ArgumentError, ~r/^Requested ending value below scale range/, fn ->
      GaugeLine.length_between_scale_values(line, 50, 0)
    end
    # End val above gauge end
    assert_raise ArgumentError, ~r/^Requested ending value above scale range/, fn ->
      GaugeLine.length_between_scale_values(line, 50, 100)
    end
  end

  test "length_between_scale_value calculates correctly" do
    # Compare to calculated known values for arbitrary line
    line1 = %GaugeLine{scaleTopVal: 100, scaleBottomVal: 0, fillTopVal: 100, fillBottomVal: 0, topX: 10, topY: 25, height: 100}
    assert GaugeLine.length_between_scale_values(line1, 0, 100) ==  100
    assert GaugeLine.length_between_scale_values(line1, 0, 50) == 50 
    assert GaugeLine.length_between_scale_values(line1, 25, 50) == 25 
    assert GaugeLine.length_between_scale_values(line1, 0, 1) ==  1
    #
    # Compare to calculated known values for arbitrary line
    line2 = %GaugeLine{scaleTopVal: 80, scaleBottomVal: 20, fillTopVal: 80, fillBottomVal: 20, topX: 10, topY: 25, height: 100}
    assert GaugeLine.length_between_scale_values(line2, 20, 80) ==  100
    assert GaugeLine.length_between_scale_values(line2, 20, 50) == 50 
    assert GaugeLine.length_between_scale_values(line2, 35, 50) == 25
    assert GaugeLine.length_between_scale_values(line2, 35, 65) == 50
  end

  test "raw_svg_dasharray_attr_string generates correct dash attributes" do
    line1 = %GaugeLine{scaleTopVal: 100, scaleBottomVal: 0, fillTopVal: 100, fillBottomVal: 0}
    assert GaugeLine.raw_svg_dasharray_attr_string(line1) == ""
    # Compare to calculated known values for arbitrary line
    line2 = %GaugeLine{scaleTopVal: 100, scaleBottomVal: 0, fillTopVal: 100, fillBottomVal: 50, topX: 10, topY: 25, height: 100}
    assert GaugeLine.raw_svg_dasharray_attr_string(line2) == " stroke-dashoffset=\"-50.0\" stroke-dasharray=\"50.0 #{line1.height}\" "
    #assert GaugeLine.length_between_scale_values(line1, 0, 50) == 50 
    #assert GaugeLine.length_between_scale_values(line1, 25, 50) == 25 
    #assert GaugeLine.length_between_scale_values(line1, 0, 1) ==  1
  end

end
