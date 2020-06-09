defmodule WeatherMoss.Meteobridge.FifteensecondScaleValues do
  @moduledoc """
  Represents the initial scale values for the data values that are updated every fifteen seconds.
  """
  alias __MODULE__
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondWind
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp

  defstruct [
    tempOutCurMax: 95,
    temOutCurMin: 0,
    rainDayMax: 10,
    windSpeedMax: 5,
  ]

  def fetch do
    ret = %FifteensecondScaleValues{}
    FifteensecondScaleValues.put_if_greater(ret, :temOutCurMax,
                                            FifteensecondRainAndTemp
                                            |> FifteensecondRainAndTemp.min_temp
                                            |> FifteensecondRainAndTemp.in_last_day
                                            |> WeatherMoss.MeteobridgeRepo.all)
    FifteensecondScaleValues.put_if_lesser(ret, :tempOutCurMin,
                                           FifteensecondRainAndTemp
                                           |> FifteensecondRainAndTemp.max_temp
                                           |> FifteensecondRainAndTemp.in_last_day
                                           |> WeatherMoss.MeteobridgeRepo.all)
    FifteensecondScaleValues.put_if_greater(ret, :rainDayMax,
                                            FifteensecondRainAndTemp
                                            |> FifteensecondRainAndTemp.max_daily_rain
                                            |> FifteensecondRainAndTemp.in_last_day
                                            |> WeatherMoss.MeteobridgeRepo.all)
    FifteensecondScaleValues.put_if_greater(ret, :windSpeedMax,
                                            FifteensecondWind
                                            |> FifteensecondWind.max_wind_speed
                                            |> FifteensecondWind.in_last_day
                                            |> WeatherMoss.MeteobridgeRepo.all)
    {:ok, ret}
  end

  # If the given val is greater than the val existing in the struct, update the val in the struct.
  def put_if_greater(%FifteensecondScaleValues{} = valStruct, key, val) do
    if val > Map.get(valStruct, key), do: Map.put(valStruct, key, val)
  end

  # If the given val is less than the val existing in the struct, update the val in the struct.
  def put_if_lesser(%FifteensecondScaleValues{} = valStruct, key, val) do
    if val < Map.get(valStruct, key), do: Map.put(valStruct, key, val)
  end
end
