defmodule WeatherMoss.FakeTempestEvents do
  @moduledoc """
  Fakes a Tempest weather station sending UDP data.
  Rather than polluting the LAN with UDP data, this module instead creates
  the parsed data and hands it directly to the Tempest.DataLogger genserver.

  Because of this it is not a good *testing* tool, since it doesn't actually test
  the UDP receiving or the parser. It is only designed to create dummy data to use
  when developing the UI when you don't happen to have a Tempest weatherstation on
  the LAN.
  """

  use GenServer
  alias WeatherMoss.Tempest.DataLogger, as: TDL

  @table :tempest_fake_events_cache

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    :ets.new(@table, [:set, :public, :named_table,
                      read_concurrency: true,
                      write_concurrency: false])
    Process.send_after(self(), :loop_event, 3000)
    Process.send_after(self(), :loop_observation, 1000)

    {:ok, %{
      latest: %{
        observation_sky: random_observation_sky(),
        observation_air: random_observation_air(),
        observation_tempest: random_observation_tempest(),
        event_precipitation: random_event_precipitation(),
        event_strike: random_event_strike(),
        rapid_wind: random_rapid_wind(),
      }
    }}
  end

  # Observations occur on a regular schedule, so we'll send a new one every minute.
  def handle_info(:loop_observation, state) do
    latest =
      state.latest
      |> Map.put(:observation_sky, random_observation_sky())
      |> Map.put(:observation_air, random_observation_air())
      |> Map.put(:observation_tempest, random_observation_tempest())

    Process.send_after(self(), :loop_observation, 60_000)
    {:noreply, %{state | latest: latest}}
  end

  # Events may or may not occur, so we'll loop fast and randomly emit different events
  def handle_info(:loop_event, state) do


    Process.send_after(self(), :loop_event, 1000)
    {:noreply, state}
  end

  defp random_observation_sky() do
    latest = case :ets.lookup(@table, :observation_sky) do
      [{:observation_sky, val}] -> val
      [] -> %{
          timestamp: DateTime.utc_now,
          hub_sn: "fakehub",
          serial_number: "fake_serial",
          illuminance_lux: Enum.random(0..100_000),
          uv_index: (Enum.random(0..600) * 0.01),
          rain_accumulated_mm: 0,
          wind_lull_ms: 0,
          wind_gust_ms: 8,
          wind_avg_ms: Enum.random(1..5),
          wind_direction_degrees: Enum.random(0..359),
          solar_radiation_wm2: Enum.random(0..600),
          local_day_rain_accumulation_mm: 0,
          precipitation_type: :none,
          wind_sample_interval_seconds: 1,
          battery_volts: 2.38,
          reportinterval_minutes: 1,
        }
    end

    updated = latest
      #|> 

  #defp new_temp(latest) do
    #case :ets.update_counter(@table, :cycles_until_bigger_temp_change, {2, -1, 0, 5}, {:cycles_until_bigger_temp_change, 5}) do
      #remaining when remaining == 0 ->
        #IO.puts("Randomizing temp change with larger jump on this 5th 30 second cycle")
        #latest.current_temp_f + Enum.random(1..5)
      #_ -> latest.current_temp_f + (Enum.random(0..5)*0.1)
    #end
  #end

    :ets.insert(@table, {:observation_sky, updated})
    updated
  end

  defp random_observation_air() do
    %{}
  end

  defp random_observation_tempest() do
    %{}
  end

  defp random_event_precipitation() do
    %{}
  end

  defp random_event_strike() do
    %{}
  end

  defp random_rapid_wind() do
    %{}
  end
end
