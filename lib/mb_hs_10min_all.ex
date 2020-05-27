defmodule WeatherMoss.MeteobridgeHousestationTenminuteAll do
  use Ecto.Schema

  @primary_key {:ID, :id, autogenerate: true}

  schema "housestation_10min_all" do
    field :DateTime, :utc_datetime
    field :TempOutCur, :decimal
    field :HumOutCur, :integer
    field :PressCur, :decimal
    field :DewCur, :decimal
    field :HeatIdxCur, :decimal
    field :WindChillCur, :decimal
    field :TempInCur, :decimal
    field :HumInCur, :integer
    field :WindSpeedCur, :decimal
    field :WindAvgSpeedCur, :decimal
    field :WindDirCur, :integer
    field :WindDirCurEng, :string
    field :WindGust10, :decimal
    field :WindDirAvg10, :integer
    field :WindDirAvg10Eng, :string
    field :UVAvg10, :decimal
    field :UVMax10, :decimal
    field :SolarRadAvg10, :decimal
    field :SolarRadMax10, :decimal
    field :RainRateCur, :decimal
    field :RainDay, :decimal
    field :RainYest, :decimal
    field :RainMonth, :decimal
    field :RainYear, :decimal
  end
end
