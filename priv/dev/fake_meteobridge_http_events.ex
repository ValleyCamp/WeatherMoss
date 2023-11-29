defmodule WeatherMoss.FakeMeteobridgeHTTPEvents do
  @moduledoc """
  When this GenServer is started it will pretend to be a Meteobridge device and
  send the http events that we're expecting to receive from the real device.

  NOTE: This is designed for use in the dev environment only, or perhaps in
        some sort of online demo, but should NOT be run in a production
        environment where a physical Meteobridge device is providing the data.
  """
  use GenServer
  require Logger

  @table :meteobridge_fake_http_events_cache

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

  @impl true
  def handle_info(:fifteensec, state) do
    data = generate_fake_fifteensec()

    with {:ok, resp} <- HTTPoison.get("http://localhost:4000/api/meteobridge/15second/new#{to_fifteensec_querystring(data)}"),
         {:ok, body} <- Jason.decode(resp.body),
         "saved" <- body["status"] do
      :ets.insert(@table, {:fifteensec, data})
    else
      err -> Logger.error("FakeMeteobridgeHTTPEvents: Could not save fake 15 second observation: #{inspect err}")
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
    data = generate_fake_tenmin()

    with {:ok, resp} <- HTTPoison.get("http://localhost:4000/api/meteobridge/10minute/new#{to_tenmin_querystring(data)}"),
         {:ok, body} <- Jason.decode(resp.body),
         "saved" <- body["status"] do
      true
    else
      err -> Logger.error("FakeMeteobridgeHTTPEvents: Could not save fake 10 minute observation: #{inspect err}")
    end

    schedule_tenmin()
    {:noreply, state}
  end


  # Note that these are *NOT* scheduled for matching real-time intervals, due to
  # FakeWeather running at a higher than real-time rate. The goal is to test the
  # UI, which will be helped by not having to wait a full 10 minutes...
  defp schedule_fifteensec do
    Process.send_after(self(), :fifteensec, :timer.seconds(10))
  end

  defp schedule_tenmin do
    Process.send_after(self(), :tenmin, :timer.seconds(400))
  end

  defp generate_fake_fifteensec() do
    c = WeatherMoss.FakeWeather.current()

    %{
      station: "fake-davis-meteobridge",
      temp_act_F: c.temp_F,
      rain_rate_act_in: mm_to_in(c.rain_accumulated_mm),
      rain_total_day_in: mm_to_in(c.rain_day_accumulated_mm),
      wind_dir_act: c.wind_dir_deg,
      wind_dir_act_en: WeatherMoss.FakeWeather.wind_dir_en(c.wind_dir_deg),
      wind_speed_act_mph: c.wind_speed_mph,
      solar_rad_act_wm2: c.wm2,
      uv_index: c.uv_index
    }
  end

  # TODO: We're gonna need to cache the 15 sec results, *OR* have FakeWeather keep the running totals...
  #       If we cache it ourselves though, then we can introduce the device-specific randomness in the 15sec
  #       data, which is then cached and used to calculate the 10min...
  defp generate_fake_tenmin() do
    c = WeatherMoss.FakeWeather.current()
    #recentFifteneSecData = WeatherMoss.Meteobridge.recent_fifteen_second_observations("fake-davis-meteobridge", 41)

    %{
      station: "fake-davis-meteobridge",
      indoor_temp_avg_F: 65.0,
      indoor_humidity_act: 0.5,
      indoor_dewpoint_act_F: 65.0,
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
      rain_total_day_in: 1,
      temp_avg_F: 42, # PLACEHOLDER, SEE Map.put BELOW
    }
    #|> Map.put(:temp_avg_F, Enum.reduce(recentFifteenSecData, 0, fn x, acc -> acc + x.temp_act_F end) / length(recentFifteenSecData) |> Float.round(2))

  end

  defp to_fifteensec_querystring(data) do
    "?station=#{data.station}&temp_act_F=#{data.temp_act_F}&rain_rate_act_in=#{data.rain_rate_act_in}&rain_total_day_in=#{data.rain_total_day_in}&wind_dir_act=#{data.wind_dir_act}&wind_dir_act_en=#{data.wind_dir_act_en}&wind_speed_act_mph=#{data.wind_speed_act_mph}&solar_rad_act_wm2=#{data.solar_rad_act_wm2}&uv_index=#{data.uv_index}"
  end

  defp to_tenmin_querystring(data) do
    "?station=#{data.station}&indoor_temp_avg_F=#{data.indoor_temp_avg_F}&indoor_humidity_act=#{data.indoor_humidity_act}&indoor_dewpoint_act_F=#{data.indoor_dewpoint_act_F}&temp_avg_F=#{data.temp_avg_F}&humidity_act=#{data.humidity_act}&dewpoint_act_F=#{data.dewpoint_act_F}&heatindex_act_F=#{data.heatindex_act_F}&pressure_act_hPa=#{data.pressure_act_hPa}&pressure_sealevel_act_inHg=#{data.pressure_sealevel_act_inHg}&wind_chill_act_F=#{data.wind_chill_act_F}&wind_speed_act_mph=#{data.wind_speed_act_mph}&wind_speed_average_mph=#{data.wind_speed_average_mph}&wind_speed_avg10_mph=#{data.wind_speed_avg10_mph}&wind_speed_max_mph=#{data.wind_speed_max_mph}&wind_dir_act=#{data.wind_dir_act}&wind_dir_act_en=#{data.wind_dir_act_en}&wind_dir_avg=#{data.wind_dir_avg}&wind_dir_avg_en=#{data.wind_dir_avg_en}&uv_index_avg=#{data.uv_index_avg}&uv_index_max=#{data.uv_index_max}&solar_rad_avg_wm2=#{data.solar_rad_avg_wm2}&solar_rad_max_wm2=#{data.solar_rad_max_wm2}&lightning_distance_avg_miles=#{data.lightning_distance_avg_miles}&lightning_energy_avg=#{data.lightning_energy_avg}&lightning_energy_max=#{data.lightning_energy_max}&lightning_strike_count=#{data.lightning_strike_count}&rain_rate_act_in=#{data.rain_rate_act_in}&rain_total_day_in=#{data.rain_total_day_in}"
  end

  defp mm_to_in(mm) do
    mm / 25.4
  end

end
