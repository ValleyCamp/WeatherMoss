defmodule WeatherMoss.Meteobridge.Housestation.TenminuteAll do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "housestation_10min_all" do
    field :dateTime, :utc_datetime
    field :tempOutCur, :decimal
    field :humOutCur, :integer
    field :pressCur, :decimal
    field :dewCur, :decimal
    field :heatIdxCur, :decimal
    field :windChillCur, :decimal
    field :tempInCur, :decimal
    field :humInCur, :integer
    field :windSpeedCur, :decimal
    field :windAvgSpeedCur, :decimal
    field :windDirCur, :integer
    field :windDirCurEng, :string
    field :windGust10, :decimal
    field :windDirAvg10, :integer
    field :windDirAvg10Eng, :string
    field :uVAvg10, :decimal
    field :uVMax10, :decimal
    field :solarRadAvg10, :decimal
    field :solarRadMax10, :decimal
    field :rainRateCur, :decimal
    field :rainDay, :decimal
    field :rainYest, :decimal
    field :rainMonth, :decimal
    field :rainYear, :decimal
  end
end
