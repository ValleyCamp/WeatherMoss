defmodule WeatherMoss.FakeMeteobridgeHTTPEvents do
  @moduledoc """
  When this GenServer is started it will pretend to be a Meteobridge device and
  send the http events that we're expecting to receive from the real device.
  It caches the previous values to make it easy to make the changes look
  natural. If your temp 15 seconds ago was -10, the temp now should not be 90.
  This allows us to test the gauge animations and such in a sensible way.

  NOTE: This is designed for use in the dev environment only, or perhaps in
        some sort of online demo, but should NOT be run in a production
        environment where a physical Meteobridge device is providing the data.
  """
  use GenServer
  require Logger

  @table :meteobridge_fake_http_events_cache
  @fifteensec_temp_inflection_after_events 40

  ## GenServer Client
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## GenServer Server
  @impl true
  def init(_) do
    :ets.new(@table, [:set, :public, :named_table,
                      read_concurrency: true,
                      write_concurrency: false])
    Process.send_after(self(), :fifteensec, 10)
    Process.send_after(self(), :tenmin, 1000)
    {:ok, %{}}
  end

  #  Gin up a fake event for all of the expected every-15-second observation values.
  #  Attempts to keep the data smooth so that we can test the UI animations and
  #  such. Don't change by too much, try and have sensible values.
  @impl true
  def handle_info(:fifteensec, state) do
    data =
      case :ets.lookup(@table, :fifteensec) do
        [{:fifteensec, val}] -> val
        [] -> generate_random_fifteensec()
      end
      |> randomly_mutate_fifteensec()

    with {:ok, resp} <- HTTPoison.get("http://localhost:4000/api/meteobridge/15second/new#{to_fifteensec_querystring(data)}"),
         {:ok, body} <- Jason.decode(resp.body),
         "saved" <- body["status"] do
      :ets.insert(@table, {:fifteensec, data})
    else
      err -> Logger.error("Could not save fake 15 second observation: #{inspect err}")
    end

    case :ets.update_counter(@table, :events_since_fifteensec_temp_inflection, {2, 1, @fifteensec_temp_inflection_after_events, 0}, {0, 0}) do
      count when count >= @fifteensec_temp_inflection_after_events -> inflect_fifteensec_temp_direction()
      _ -> :ok
    end

    schedule_fifteensec()
    {:noreply, state}
  end

  # Create a new record for the 10 minute interval table, and schedule another
  # one to be created in 10 more minutes.
  # Attempts to have reasonable values and keep tha data fairly smooth by not
  # changing more than is reasonable in a 10-minute period in the real world.
  # Note that the tenmin values will depend on the most recent fifteensec
  # values existing, as a way to try and keep the data smooth.
  @impl true
  def handle_info(:tenmin, state) do
    mostRecentTenMin = case :ets.lookup(@table, :tenmin) do
      [{:tenmin, val}] -> val
      [] -> generate_random_tenmin()
    end
    lastTenMinutesOfData = WeatherMoss.Meteobridge.recent_fifteen_second_observations("fake-dev-station", 41)
    newTenMin = update_tenmin_values(mostRecentTenMin, lastTenMinutesOfData)

    with {:ok, resp} <- HTTPoison.get("http://localhost:4000/api/meteobridge/10minute/new#{to_tenmin_querystring(newTenMin)}"),
         {:ok, body} <- Jason.decode(resp.body),
         "saved" <- body["status"] do
      :ets.insert(@table, {:tenmin, newTenMin})
    else
      err -> Logger.error("Could not save fake 10 minute observation: #{inspect err}")
    end

    schedule_tenmin()
    {:noreply, state}
  end


  defp schedule_fifteensec do
    Process.send_after(self(), :fifteensec, :timer.seconds(10))
  end

  defp schedule_tenmin do
    Process.send_after(self(), :tenmin, :timer.seconds(600))
  end

  # For now this isn't actually random, no point, we'll just start here and
  # let the mutate handle it.
  defp generate_random_fifteensec() do
    %{
      station: "fake-dev-station",
      temp_act_F: 65.0,
      rain_rate_act_in: 0.01,
      rain_total_day_in: 0.1,
      wind_dir_act: 180,
      wind_dir_act_en: "S",
      wind_speed_act_mph: 2.25,
      solar_rad_act_wm2: 100.0,
      uv_index: 1.0
    }
  end

  defp randomly_mutate_fifteensec(cur) do
    tempDir = case :ets.lookup(@table, :fifteensec_temp_direction) do
      [{:fifteensec_temp_direction, val}] -> val
      [] -> 1
    end

    newWindDirDeg = cur.wind_dir_act + (Enum.random(0..90)*Enum.random(-1..1))
    newWindDirEn = wind_dir_en(newWindDirDeg)
    cur
    |> Map.put(:temp_act_F, cur.temp_act_F + ((Enum.random(0..5) * 0.1) * tempDir))
    |> Map.put(:rain_rate_act_in, cur.rain_rate_act_in)
    |> Map.put(:rain_total_day_in, cur.rain_total_day_in + (cur.rain_rate_act_in/60/4))
    |> Map.put(:wind_dir_act, newWindDirDeg)
    |> Map.put(:wind_dir_act_en, newWindDirEn)
    |> Map.put(:wind_speed_act_mph, cur.wind_speed_act_mph + (Enum.random(0..5) * 0.1)*Enum.random(-1..1))
    |> Map.put(:solar_rad_act_wm2, cur.solar_rad_act_wm2 + (Enum.random(5..10) * Enum.random(-1..1)))
    |> Map.put(:uv_index, cur.uv_index + (Enum.random(0..1) * Enum.random(-1..1)))
  end

  # Temps should rise for a bit, then fall for a bit, then rise for a bit, etc.
  defp inflect_fifteensec_temp_direction() do
    newDirection = case :ets.lookup(@table, :fifteensec_temp_direction) do
      [{:fifteensec_temp_direction, -1}] -> 1
      [{:fifteensec_temp_direction, 1}] -> -1
      [{:fifteensec_temp_direction, _}] -> 1
      [] -> 1
    end
    :ets.insert(@table, {:fifteensec_temp_direction, newDirection})
  end

  defp to_fifteensec_querystring(data) do
    "?station=#{data.station}&temp_act_F=#{data.temp_act_F}&rain_rate_act_in=#{data.rain_rate_act_in}&rain_total_day_in=#{data.rain_total_day_in}&wind_dir_act=#{data.wind_dir_act}&wind_dir_act_en=#{data.wind_dir_act_en}&wind_speed_act_mph=#{data.wind_speed_act_mph}&solar_rad_act_wm2=#{data.solar_rad_act_wm2}&uv_index=#{data.uv_index}"
  end

  defp generate_random_tenmin() do
    %{
      station: "fake-dev-station",
      indoor_temp_avg_F: 65.0,
      indoor_humidity_act: 0.5,
      indoor_dewpoint_act_F: 65.0,
      temp_avg_F: 65.0,
      humidity_act: 0.5,
      dewpoint_act_F: 65.0,
      heatindex_act_F: 65.0,
      pressure_act_hPa: 29.92,
      pressure_sealevel_act_inHg: 29.92,
      wind_chill_act_F: 65.0,
      wind_speed_act_mph: 2.25,
      wind_speed_average_mph: 3.75,
      wind_speed_avg10_mph: 4.5,
      wind_speed_max_mph: 6,
      wind_dir_act: 180,
      wind_dir_act_en: "S",
      wind_dir_avg: 90,
      wind_dir_avg_en: "E",
      uv_index_avg: 5,
      uv_index_max: 12,
      solar_rad_avg_wm2: 20,
      solar_rad_max_wm2: 30,
      lightning_distance_avg_miles: 0,
      lightning_energy_avg: 0,
      lightning_energy_max: 0,
      lightning_strike_count: 0,
      rain_rate_act_in: 0.5,
      rain_total_day_in: 1
    }
  end

  defp update_tenmin_values(cur, recentFifteenSecData) do
    new_wind_dir_avg = Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.wind_dir_act end) / length(recentFifteenSecData) |> Float.round(0)
    new_wind_dir_avg_en = wind_dir_en(new_wind_dir_avg)

    lightning = case Enum.random([-1, 1]) do
      -1 -> %{lightning_distance_avg_miles: 0, lightning_energy_avg: 0, lightning_energy_max: 0, lightning_strike_count: 0}
      1 ->
        strikes = Enum.random(5..50)
        max = Enum.random(10..100)
        avg = max/strikes |> Float.round(0)
        %{lightning_distance_avg_miles: Enum.random(1..10), lightning_energy_avg: avg, lightning_energy_max: max, lightning_strike_count: strikes}
    end

    # Note that these depend blindly on the most recent 15 second data being the first in the list. (DESC sort)
    # TODO: Add a test that verifies that the context does that
    cur
    |> Map.put(:temp_avg_F, Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.temp_act_F end) / length(recentFifteenSecData) |> Float.round(2))
    |> Map.put(:rain_rate_act_in, Enum.at(recentFifteenSecData, 0).rain_rate_act_in)
    |> Map.put(:rain_total_day_in, Enum.at(recentFifteenSecData, 0).rain_total_day_in)
    |> Map.put(:wind_dir_act, Enum.at(recentFifteenSecData, 0).wind_dir_act)
    |> Map.put(:wind_dir_act_en, Enum.at(recentFifteenSecData, 0).wind_dir_act_en)
    |> Map.put(:wind_speed_act_mph, Enum.at(recentFifteenSecData, 0).wind_speed_act_mph + rand_half_unit_change())
    |> Map.put(:wind_speed_average_mph, Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.wind_speed_act_mph end) / length(recentFifteenSecData) |> Float.round(2))
    |> Map.put(:wind_speed_avg10_mph, (Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.wind_speed_act_mph end) / length(recentFifteenSecData) |> Float.round(2)) + rand_half_unit_change())
    |> Map.put(:wind_speed_max_mph, Enum.max_by(recentFifteenSecData, &(&1.wind_speed_act_mph)).wind_speed_act_mph)
    |> Map.put(:wind_dir_avg, new_wind_dir_avg)
    |> Map.put(:wind_dir_avg_en, new_wind_dir_avg_en)
    |> Map.put(:uv_index_avg, Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.uv_index end) / length(recentFifteenSecData) |> Float.round(2))
    |> Map.put(:uv_index_max, Enum.max_by(recentFifteenSecData, &(&1.uv_index)).uv_index)
    |> Map.put(:solar_rad_avg_wm2, Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.solar_rad_act_wm2 end) / length(recentFifteenSecData) |> Float.round(2))
    |> Map.put(:solar_rad_max_wm2, Enum.max_by(recentFifteenSecData, &(&1.solar_rad_act_wm2)).solar_rad_act_wm2)
    |> Map.put(:indoor_temp_avg_F, cur.indoor_temp_avg_F + rand_half_unit_change())
    |> Map.put(:indoor_humidity_act, cur.indoor_humidity_act + rand_half_unit_change())
    |> Map.put(:indoor_dewpoint_act_F, cur.indoor_dewpoint_act_F + rand_half_unit_change())
    |> Map.put(:dewpoint_act_F, cur.dewpoint_act_F + rand_half_unit_change())
    |> Map.put(:heatindex_act_F, cur.heatindex_act_F + rand_half_unit_change())
    |> Map.put(:pressure_act_hPa, cur.pressure_act_hPa + Enum.random([-1, 1]))
    |> Map.put(:pressure_sealevel_act_inHg, cur.pressure_sealevel_act_inHg + Enum.random([-1, 1]))
    |> Map.put(:wind_chill_act_F, cur.wind_chill_act_F + rand_half_unit_change())
    |> Map.put(:lightning_distance_avg_miles, lightning.lightning_distance_avg_miles)
    |> Map.put(:lightning_energy_avg, lightning.lightning_energy_avg)
    |> Map.put(:lightning_energy_max, lightning.lightning_energy_max)
    |> Map.put(:lightning_strike_count, lightning.lightning_strike_count)
  end

  defp to_tenmin_querystring(data) do
    "?station=#{data.station}&indoor_temp_avg_F=#{data.indoor_temp_avg_F}&indoor_humidity_act=#{data.indoor_humidity_act}&indoor_dewpoint_act_F=#{data.indoor_dewpoint_act_F}&temp_avg_F=#{data.temp_avg_F}&humidity_act=#{data.humidity_act}&dewpoint_act_F=#{data.dewpoint_act_F}&heatindex_act_F=#{data.heatindex_act_F}&pressure_act_hPa=#{data.pressure_act_hPa}&pressure_sealevel_act_inHg=#{data.pressure_sealevel_act_inHg}&wind_chill_act_F=#{data.wind_chill_act_F}&wind_speed_act_mph=#{data.wind_speed_act_mph}&wind_speed_average_mph=#{data.wind_speed_average_mph}&wind_speed_avg10_mph=#{data.wind_speed_avg10_mph}&wind_speed_max_mph=#{data.wind_speed_max_mph}&wind_dir_act=#{data.wind_dir_act}&wind_dir_act_en=#{data.wind_dir_act_en}&wind_dir_avg=#{data.wind_dir_avg}&wind_dir_avg_en=#{data.wind_dir_avg_en}&uv_index_avg=#{data.uv_index_avg}&uv_index_max=#{data.uv_index_max}&solar_rad_avg_wm2=#{data.solar_rad_avg_wm2}&solar_rad_max_wm2=#{data.solar_rad_max_wm2}&lightning_distance_avg_miles=#{data.lightning_distance_avg_miles}&lightning_energy_avg=#{data.lightning_energy_avg}&lightning_energy_max=#{data.lightning_energy_max}&lightning_strike_count=#{data.lightning_strike_count}&rain_rate_act_in=#{data.rain_rate_act_in}&rain_total_day_in=#{data.rain_total_day_in}"
  end

  defp rand_half_unit_change() do
    (Enum.random(0..5)*0.1) * Enum.random([-1, 1])
  end

  defp wind_dir_en(degrees) do
    directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    segmentWidth = 360 / length(directions)

    # Rotate the dial half a segment to counter clockwise, so that "north" covers a full segment width centered on 0 degrees.
    targetDirectionWithOffset = case ((0 - (segmentWidth/2)) + degrees) do
      r when r < 0 -> r+360
      r -> r
    end

    dirIndex =  div(trunc(targetDirectionWithOffset), trunc(segmentWidth))

    Enum.at(directions, dirIndex)
  end
end
