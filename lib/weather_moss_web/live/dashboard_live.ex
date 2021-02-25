defmodule WeatherMossWeb.DashboardLive do
  @moduledoc """
  Note that this module brings everything out of the Decimal datatype used in WeatherMoss.Meteobridge
  and represents it as a float, in order to make everything easier to work with. No concern about loss
  of precision, since we're just displaying the values here, not putting them back into the DB or anything.
  """
  use WeatherMossWeb, :live_view

  import WeatherMossWeb.ViewHelpers
  alias WeatherMossWeb.GaugeLine
  alias WeatherMossWeb.GaugeArc

  @impl true
  def mount(_params, _session, socket) do
    # Note that we could do a calculation here and try and get the send interval to line up with the 
    # insertion of values into the DB, however this would cause load spikes every 15 seconds as every
    # client requested at the same time, so we'll just do arbitrary 15 second cycles depending per-client.
    if connected?(socket), do: :timer.send_interval(15000, self(), :update)

    {:ok, build_assigns(socket)}
  end

  @impl true
  def handle_info(:update, socket) do
    {:noreply, build_assigns(socket)}
  end



  defp build_assigns(socket) do
    {:ok, meteobridge_latest} = WeatherMoss.Meteobridge.latest
    {:ok, meteobridge_scale_values} = WeatherMoss.Meteobridge.get_scale_vals

    fifteen_second_temperature_gauge = %GaugeLine{
      html_id: "fifteen_second_temperature_gauge",
      main_label_text: "Temperature",
      scaleBottomVal: Decimal.to_float(meteobridge_scale_values.fifteenSecond.tempOutCurMin),
      scaleTopVal: Decimal.to_float(meteobridge_scale_values.fifteenSecond.tempOutCurMax),
      fillBottomVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.tempOutCur),
      fillTopVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.tempOutCur),
      curVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.tempOutCur),
    } |> GaugeLine.build_initial_values()

    fifteen_second_rain_gauge = %GaugeLine{
      html_id: "fifteen_second_rain_gauge",
      main_label_text: "Daily Rain",
      scaleBottomVal: 0.0,
      scaleTopVal: Decimal.to_float(meteobridge_scale_values.fifteenSecond.rainDayMax),
      fillBottomVal: 0.0,
      fillTopVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.rainDay),
      curVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.rainDay),
    } |> GaugeLine.build_initial_values()

    fifteen_second_wind_gauge = %GaugeArc{
      html_id: "fifteen_second_wind_gauge",
      main_label_text: "Wind",
      scaleBottomVal: 0,
      scaleTopVal: Decimal.to_float(meteobridge_scale_values.fifteenSecond.windSpeedMax),
      fillStartVal: 0,
      fillEndVal: Decimal.to_float(meteobridge_latest.fifteensec_wind.windSpeedCur),
      curVal: Decimal.to_float(meteobridge_latest.fifteensec_wind.windSpeedCur),
      windDirCur: meteobridge_latest.fifteensec_wind.windDirCur,
      windDirCurEng: meteobridge_latest.fifteensec_wind.windDirCurEng,
    } |> GaugeArc.build_initial_values()

    arg_list = Keyword.new()
      |> Keyword.put_new(:meteobridge_latest, meteobridge_latest)
      |> Keyword.put_new(:fifteen_second_temperature_gauge, fifteen_second_temperature_gauge)
      |> Keyword.put_new(:fifteen_second_rain_gauge, fifteen_second_rain_gauge)
      |> Keyword.put_new(:fifteen_second_wind_gauge, fifteen_second_wind_gauge)

    assign(socket, arg_list)
  end
end

