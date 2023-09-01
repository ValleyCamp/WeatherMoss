defmodule WeatherMossWeb.DashboardLive.Index do
  use WeatherMossWeb, :live_view
  import WeatherMossWeb.WidgetComponents;
  alias WeatherMossWeb.Support.{GaugeLine, GaugeArc};

  @impl true
  def mount(_params, _session, socket) do
    # Note that we could do a calculation here and try and get the send interval to line up with the 
    # insertion of values into the DB, however this would cause load spikes every 15 seconds as every
    # client requested at the same time, so we'll just do arbitrary 15 second cycles depending per-client.
    # NOTE: Should we be switching to the standard approach of
    #       if connected?(socket), do: Process.send_after(self(), :update_meteobridge, 30000)
    #       and calling Procces.send_after again in the handle_info(:update_meteobridge, socket)
    #       If we do that though we would be subject to slow drift for long-running sessions?
    #       Perhaps it's time to take another look at if mysql can notify us of updates, rather than polling...
    if connected?(socket), do: :timer.send_interval(15000, self(), :update_meteobridge)

    {:ok, build_assigns(socket)}
  end

  @impl true
  def handle_info(:update_meteobridge, socket) do
    {:noreply, build_assigns(socket)}
  end

  @impl true
  def handle_params(params, _url, socket), do: apply_action(socket, socket.assigns.live_action, params)

  defp apply_action(socket, :index, _params), do: {:noreply, build_assigns(socket)}


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

    fifteen_second_rain_rate_gauge = %GaugeLine{
      html_id: "fifteen_second_rain_rate",
      main_label_text: "Rain Rate",
      scaleBottomVal: 0,
      scaleTopVal: Decimal.to_float(meteobridge_scale_values.fifteenSecond.rainRateMax),
      fillBottomVal: 0.0,
      fillTopVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.rainRateCur),
      curVal: Decimal.to_float(meteobridge_latest.fifteensec_raintemp.rainRateCur),
    } |> GaugeLine.build_initial_values()

    socket
      |> assign(:meteobridge_latest, meteobridge_latest)
      |> assign(:fifteen_second_temperature_gauge, fifteen_second_temperature_gauge)
      |> assign(:fifteen_second_rain_gauge, fifteen_second_rain_gauge)
      |> assign(:fifteen_second_wind_gauge, fifteen_second_wind_gauge)
      |> assign(:fifteen_second_rain_rate_gauge, fifteen_second_rain_rate_gauge)
  end
end
