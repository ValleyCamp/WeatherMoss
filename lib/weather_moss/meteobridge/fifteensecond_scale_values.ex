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

  @doc """
  Get a new FifteensecondScaleValues, calculating all of the values based on values from the database.
  """
  @spec fetch() :: FifteensecondScaleValues.t()
  def fetch do
    ret = %FifteensecondScaleValues{} 
    ret = FifteensecondScaleValues.put_if_greater(ret, :temOutCurMax,
                                                        FifteensecondRainAndTemp
                                                        |> FifteensecondRainAndTemp.max_temp
                                                        |> FifteensecondRainAndTemp.in_last_month
                                                        |> WeatherMoss.MeteobridgeRepo.one)
    |> FifteensecondScaleValues.put_if_lesser(:tempOutCurMin,
                                               FifteensecondRainAndTemp
                                               |> FifteensecondRainAndTemp.min_temp
                                               |> FifteensecondRainAndTemp.in_last_month
                                               |> WeatherMoss.MeteobridgeRepo.one)
    |> FifteensecondScaleValues.put_if_greater(:rainDayMax,
                                                FifteensecondRainAndTemp
                                                |> FifteensecondRainAndTemp.max_daily_rain
                                                |> FifteensecondRainAndTemp.in_last_month
                                                |> WeatherMoss.MeteobridgeRepo.one)
    |> FifteensecondScaleValues.put_if_greater(:windSpeedMax,
                                                FifteensecondWind
                                                |> FifteensecondWind.max_wind_speed
                                                |> FifteensecondWind.in_last_month
                                                |> WeatherMoss.MeteobridgeRepo.one)
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
