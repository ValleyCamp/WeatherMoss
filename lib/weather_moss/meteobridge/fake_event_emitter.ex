defmodule WeatherMoss.Meteobridge.FakeEventEmitter do
  @moduledoc """
  When this GenServer is started it will pretend to be a Meteobridge device inserting values into the database at the correct intervals.
  It caches the previous values to make it easy to make the changes look natural. If your temp 15 seconds ago was -10, the temp now should not be 90.
  This allows us to test the gauge animations and such in a sensible way.

  NOTE: This is designed for use in the dev environment only, or perhaps in some sort of online demo, but should NOT be run in a production
        environment where a physical Meteobridge device is inserting data into the database.
  """
  #import Ecto.Query 
  use GenServer 
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondWind
  alias WeatherMoss.Meteobridge.Housestation.TenminuteAll

  @table :meteobridge_fakeemitter_cache
  @fifteensec_temp_inflection_after_cycles 40
  @fifteensec_wind_inflection_after_cycles 2

  ## GenServer Client
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  ## GenServer Server
  def init(_) do
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true, write_concurrency: false])
    Process.send_after(self(), :fifteensec, 1)
    Process.send_after(self(), :tenminute, 1)
    {:ok, %{}}
  end

  @doc """
  Create a new record for both of the 15 second interval tables, and schedule another call in 15 more seconds.
  Attempts to keep the data smooth so that we can test the UI animations and such. Don't change by too much, try and have sensible values.
  """
  def handle_info(:fifteensec, state) do
    # Process a new FifteensecondRainTemp
    previousFifteensecRaintemp = case :ets.lookup(@table, :fifteensec_raintemp) do
      [{:fifteensec_raintemp, val}] -> val
      [] -> generate_random_fifteensec_raintemp()
    end
    newRainTemp = randomly_mutate_fifteensec_raintemp(previousFifteensecRaintemp)
    case :ets.update_counter(@table, :cycles_since_fifteensec_temp_inflection, {2, 1, @fifteensec_temp_inflection_after_cycles, 0}, {0, 0}) do
      count when count == @fifteensec_temp_inflection_after_cycles -> randomize_fifteensec_temp_direction()
      _ -> :ok
    end

    # Process a new FifteensecondWind
    previousFifteensecWind = case :ets.lookup(@table, :fifteensec_wind) do
      [{:fifteensec_wind, val}] -> val
      [] -> generate_random_fifteensec_wind()
    end
    newWind = randomly_mutate_fifteensec_wind(previousFifteensecWind)
    case :ets.update_counter(@table, :cycles_since_fifteensec_wind_inflection, {2, 1, @fifteensec_wind_inflection_after_cycles, 0}, {0, 0}) do
      count when count == @fifteensec_wind_inflection_after_cycles -> randomize_fifteensec_wind_modifier()
      _ -> :ok
    end

    #WeatherMoss.Meteobridge.Repo.transaction fn ->
      WeatherMoss.MeteobridgeRepo.insert!(newRainTemp)
      WeatherMoss.MeteobridgeRepo.insert!(newWind)
    #end

    :ets.insert(@table, {:fifteensec_raintemp, newRainTemp})
    schedule_fifteensec()
    {:noreply, state}
  end

  @doc """
  Create a new record for the 10 minute interval table, and schedule another one to be created in 10 more minutes.
  Attempts to have reasonable values and keep tha data fairly smooth by not changing more than is reasonable in a 10-minute period in the real world.
  """
  def handle_info(:tenminute, state) do
    # Process a new TenminuteAll
    previousTenminuteAll = case :ets.lookup(@table, :tenminute_all) do
      [{:tenminute_all, val}] -> val
      [] -> generate_random_tenminute_all()
    end
    newTenMinuteAll = randomly_mutate_tenminute_all(previousTenminuteAll)

    WeatherMoss.MeteobridgeRepo.insert!(newTenMinuteAll)

    schedule_tenminute()
    {:noreply, state}
  end


  ## Internal Methods

  defp schedule_fifteensec do
    Process.send_after(self(), :fifteensec, :timer.seconds(15))
  end

  defp schedule_tenminute do
    Process.send_after(self(), :tenminute, :timer.seconds(600))
  end

  # Generate a new random fifteensec_raintemp from scratch
  defp generate_random_fifteensec_raintemp do
    %FifteensecondRainAndTemp{dateTime: DateTime.truncate(DateTime.utc_now, :second), tempOutCur: Enum.random(-10..90)+(Enum.random(0..1)*0.01), rainRateCur: Enum.random(0..1)*0.01, rainDay: 0.00}
  end

  # Take an existing FifteensecandRainAndTemp and 
  defp randomly_mutate_fifteensec_raintemp(cur) do
    tempDirection = case :ets.lookup(@table, :fifteensec_temp_direction) do
      [{:fifteensec_temp_direction, val}] -> val
      [] -> 1
    end

    newTemp = cur.tempOutCur + ((Enum.random(0..5)*0.01) * tempDirection)
    newRainRate = Enum.random(0..4)*0.01

    cur
    |> Map.put(:dateTime, DateTime.truncate(DateTime.utc_now, :second))
    |> Map.put(:rainDay, cur.rainDay + cur.rainRateCur)
    |> Map.put(:tempOutCur, newTemp)
    |> Map.put(:rainRateCur, newRainRate)
  end

  # Called when we reach a number of cycles dictating an inflection point, we randomize if the temp is climbing or falling until the next inflection
  defp randomize_fifteensec_temp_direction do
    :ets.insert(@table, {:fifteensec_temp_direction, Enum.random([-1, 1])})
  end



  # Generate a new random fifteensec_wind from scratch
  defp generate_random_fifteensec_wind do
    newWindDir = Enum.random(0..360)
    %FifteensecondWind{dateTime: DateTime.truncate(DateTime.utc_now, :second), windDirCur: newWindDir, windDirCurEng: windDirEng_for_windDir(newWindDir), windSpeedCur: Enum.random(0..5)+(Enum.random(0..10)*0.1)}
  end

  # Take an existing FifteensecandRainAndTemp and  modife it's values in a convincingly realistic manner in order to jk
  defp randomly_mutate_fifteensec_wind(cur) do
    windModifier = case :ets.lookup(@table, :fifteensec_wind_modifier) do
      [{:fifteensec_wind_modifier, val}] -> val
      [] -> 1
    end

    newWindspeedCur = case windModifier do
      m when m == -1 -> cur.windSpeedCur + (Enum.random(0..5)*0.01)
      m when m == 1 -> cur.windSpeedCur + (Enum.random(0..5)*0.05)
      _m -> cur.windSpeedCur #The fallthrough case, or when == 0, so wind not changing.
    end
    newWindDir = cur.windDirCur + (Enum.random(0..5) * Enum.random([-1, 1]))

    cur
    |> Map.put(:dateTime, DateTime.truncate(DateTime.utc_now, :second))
    |> Map.put(:windDirCur, newWindDir)
    |> Map.put(:windDirCurEng, windDirEng_for_windDir(newWindDir))
    |> Map.put(:windSpeedCur, newWindspeedCur)
  end

  # Called when we reach a number of cycles dictating an inflection point, we randomize if the temp is climbing or falling until the next inflection
  defp randomize_fifteensec_wind_modifier do
    :ets.insert(@table, {:fifteensec_wind_modifier, Enum.random([-1, 0, 1])})
  end

  defp windDirEng_for_windDir(degrees) do
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



  # Generate a new random tenminute_all from scratch
  # We're going to use arbitrary values based on a arbitrary record from the production database, and use those as
  # a starting point for "sensible" values.
  # It's worth noting that these will *NOT* match the values from the every-15-second records generated above.
  # We could make them match of course, but there's not much point at the moment.
  defp generate_random_tenminute_all do
    %TenminuteAll{
      dateTime: DateTime.truncate(DateTime.utc_now, :second),
      tempOutCur: 51.3,
      humOutCur: 98,
      pressCur: 30.07,
      dewCur: 50.7,
      heatIdxCur: 51.3,
      windChillCur: 51.3,
      tempInCur: 65.5,
      humInCur: 44,
      windSpeedCur: 0.0,
      windAvgSpeedCur: 0.0,
      windDirCur: 219,
      windDirCurEng: "SW",
      windGust10: 2.0,
      windDirAvg10: 200,
      windDirAvg10Eng: "SSW",
      uVAvg10: 1.40,
      uVMax10: 1.70,
      solarRadAvg10: 208.10,
      solarRadMax10: 271.00,
      rainRateCur: 0.06,
      rainDay: 0.63,
      rainYest: 0.17,
      rainMonth: 2.11,
      rainYear: 84.16
  }
  end

  defp randomly_mutate_tenminute_all(cur) do
    cur  #Haha, it's the same. GL testing animations dummy!
  end
end
