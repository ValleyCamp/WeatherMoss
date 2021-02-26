defmodule WeatherMoss.Meteobridge.FifteensecondScaleValues do
  @moduledoc """
  Represents the initial scale values for the data values that are updated every fifteen seconds.
  Note that this module uses Decimals to represent values so that they are the same type as the Ecto schemas.
  This eases the cognitive workload by knowing everything internal to WeatherMoss.Meteobridge uses Decimal
  """
  alias __MODULE__
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondWind
  alias WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp

  #@enforce_keys [:tempOutCurMax, :tempOutCurMin, :rainDayMax, :windSpeedMax]
  defstruct [
    tempOutCurMax: Decimal.new("90.0"),
    tempOutCurMin: Decimal.new("30.0"),
    rainDayMax: Decimal.new("10.0"),
    windSpeedMax: Decimal.new("5.0"),
  ]

  @type t() :: %__MODULE__{
    tempOutCurMax: Decimal.t(),
    tempOutCurMin: Decimal.t(),
    rainDayMax: Decimal.t(),
    windSpeedMax: Decimal.t()
  }


  @doc """
  Get a new FifteensecondScaleValues, calculating all of the values based on values from the database.
  """
  @spec fetch() :: FifteensecondScaleValues.t()
  def fetch do
    ret = %WeatherMoss.Meteobridge.FifteensecondScaleValues{} 
          |> FifteensecondScaleValues.put_if_greater(:temOutCurMax,
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

  @doc """
  If the given val is greater than the val existing in the struct for the given key, update the val in the struct.
  """
  @spec put_if_greater(FifteenSecondScaleValues.t(), Decimal.t(), Decimal.t()) :: Map.t()
  def put_if_greater(%FifteensecondScaleValues{} = valStruct, key, val) do
    if val > Map.get(valStruct, key), do: Map.put(valStruct, key, val)
  end

  @doc """
  If the given val is less than the val existing in the struct for the given key, update the val in the struct.
  """
  @spec put_if_lesser(FifteensecondScaleValues.t(), Decimal.t(), Decimal.t()) :: Map.t()
  def put_if_lesser(%FifteensecondScaleValues{} = valStruct, key, val) do
    if val < Map.get(valStruct, key), do: Map.put(valStruct, key, val)
  end
end
