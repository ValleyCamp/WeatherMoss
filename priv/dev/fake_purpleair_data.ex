defmodule WeatherMoss.FakePurpleairData do
  @moduledoc """
  This module is designed to create fake purpleair data and insert it into an
  ETS table where it can be read by the WeatherMossWeb.FakePurpleairDataController.

  This data should not be used for end-to-end testing, but only for developing the
  UI when you don't have a purpleair device available to request data from.

  ## AQI Color Codes
  0-50: good (green)
  51-100: moderate (yellow)
  101-150: unhealthy for sensitive groups (orange)
  151-200: unhealthy (red)
  201-300: very unhealthy (purple)
  301-500: hazardous (maroon)
  """
  use GenServer

  @table :purpleair_fakedata_cache

  ## GenServer Client
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## GenServer Server
  @impl true
  def init(_) do
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true, write_concurrency: false])
    generate_random_purpleair_data()
    Process.send_after(self(), :loop, 1000)
    {:ok, %{}}
  end

  # Every 30 seconds we'll simply change the data in the ETS table in a
  # random but convincingly realistic way.
  # We do 30 seconds, even though the app asks for data less frequently,
  # to allow a bit more variation between samples.
  @impl true
  def handle_info(:loop, state) do
    latest = case :ets.lookup(@table, :latest) do
      [{:latest, data}] -> data
      [] -> generate_random_purpleair_data()
    end

    ts = NaiveDateTime.local_now
    new =
      latest
      |> Map.put(:DateTime, ts)
      |> Map.put(:inserted_at, ts)
      |> Map.put(:updated_at, ts)
      |> Map.put(:current_temp_f, new_temp(latest))
      |> Map.put(:current_humidity, latest.current_humidity + (Enum.random(0..5)*0.1))
      |> Map.put(:pm2_5_aqi, latest.pm2_5_aqi + Enum.random([-1, 1]))
      |> Map.put(:pm2_5_aqi_b, latest.pm2_5_aqi_b + Enum.random([-1, 1]))
      |> Map.put(:pressure, latest.pressure + (Enum.random([-1, 1])*0.1))

    :ets.insert(@table, {:latest, new})
    Process.send_after(self(), :loop, 30_000)
    {:noreply, state}
  end

  def generate_random_purpleair_data() do
    ts = NaiveDateTime.local_now |> NaiveDateTime.add(-8, :minute)

    d = %{
      id: 13,
      SensorId: "8:3a:8d:cb:b3:19",
      DateTime: ts,
      rssi: -72,
      current_temp_f: 68.0,
      current_humidity: 53.0,
      current_dewpoint_f: 50.0,
      pressure: 990.14,
      current_temp_f_680: 68.0,
      current_humidity_680: 53.0,
      current_dewpoint_f_680: 50.0,
      pressure_680: 990.14,
      gas_680: 108.2,
      p25aqic: "rgb(10,229,0)",
      p25aqic_b: "rgb(10,229,0)",
      pm2_5_aqi: 17.0,
      pm2_5_aqi_b: 17.0,
      pm1_0_cf_1: 3.0,
      pm2_5_cf_1: 4.0,
      pm10_0_cf_1: 6.0,
      pm1_0_atm: 3.0,
      pm2_5_atm: 4.0,
      pm10_0_atm: 6.0,
      p_0_3_um: 612.0,
      p_0_5_um: 182.0,
      p_1_0_um: 28.0,
      p_2_5_um: 3.0,
      p_5_0_um: 2.0,
      p_10_0_um: 1.0,
      pm1_0_cf_1_b: 3.0,
      pm2_5_cf_1_b: 4.0,
      pm10_0_cf_1_b: 4.0,
      pm1_0_atm_b: 3.0,
      pm2_5_atm_b: 4.0,
      pm10_0_atm_b: 4.0,
      p_0_3_um_b: 543.0,
      p_0_5_um_b: 155.0,
      p_1_0_um_b: 26.0,
      p_2_5_um_b: 0.0,
      p_5_0_um_b: 0.0,
      p_10_0_um_b: 0.0,
      inserted_at: ts,
      updated_at: ts
    }

    :ets.insert(@table, {:latest, d})
  end

  defp new_temp(latest) do
    case :ets.update_counter(@table, :cycles_until_bigger_temp_change, {2, -1, 0, 5}, {:cycles_until_bigger_temp_change, 5}) do
      remaining when remaining == 0 ->
        IO.puts("Randomizing temp change with larger jump on this 5th 30 second cycle")
        latest.current_temp_f + Enum.random(1..5)
      _ -> latest.current_temp_f + (Enum.random(0..5)*0.1)
    end
  end

end
