defmodule WeatherMoss.Meteobridge.Housestation.TenminuteAll do
  use Ecto.Schema
  use WeatherMoss.Meteobridge.Housestation.SharedQueries
  use WeatherMoss.Meteobridge.Housestation.SharedRainAndTempQueries
  import Ecto.Query
  import Ecto.Changeset
  alias __MODULE__

  @primary_key {:id, :id, autogenerate: true}

  # The SQL Query we use to insert this data from the Meteobridge services interface:
  # INSERT INTO `housestation_10min_all` (`DateTime`, `TempOutCur`, `HumOutCur`, `PressCur`, `DewCur`, `HeatIdxCur`, `WindChillCur`, `TempInCur`, `HumInCur`, `WindSpeedCur`, `WindAvgSpeedCur`, `WindDirCur`, `WindDirCurEng`, `WindGust10`, `WindDirAvg10`, `WindDirAvg10Eng`, `UVAvg10`, `UVMax10`, `SolarRadAvg10`, `SolarRadMax10`, `RainRateCur`, `RainDay`, `RainYest`, `RainMonth`, `RainYear`) VALUES ('[YYYY]-[MM]-[DD] [hh]:[mm]:[ss]', '[th0temp-act=F]', '[th0hum-act]', '[thb0seapress-act=inHg.2]', '[th0dew-act=F]', '[th0heatindex-act=F]', '[wind0chill-act=F]', '[thb0temp-act=F]', '[thb0hum-act]', '[wind0wind-act=mph]', '[wind0avgwind-act=mph]', '[wind0dir-act]', '[wind0dir-act=endir]', '[wind0wind-max10=mph]', '[wind0dir-avg10]', '[wind0dir-avg10=endir]', '[uv0index-avg10]', '[uv0index-max10]', '[sol0rad-avg10]', '[sol0rad-max10]', '[rain0rate-act=in.2]', '[rain0total-daysum=in.2]', '[rain0total-ydaysum=in.2]', '[rain0total-monthsum=in.2]', '[rain0total-yearsum=in.2]')
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
    field :rainYear, :decimal      #NOTE: This is for the "meteorological year", Oct 1st to Sept 30th
  end

  def changeset(%TenminuteAll{} = struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [
      :dateTime,
      :tempOutCur,
      :humOutCur,
      :pressCur,
      :dewCur,
      :heatIdxCur,
      :windChillCur,
      :tempInCur,
      :humInCur,
      :windSpeedCur,
      :windAvgSpeedCur,
      :windDirCur,
      :windDirCurEng,
      :windGust10,
      :windDirAvg10,
      :windDirAvg10Eng,
      :uVAvg10,
      :uVMax10,
      :solarRadAvg10,
      :solarRadMax10,
      :rainRateCur,
      :rainDay,
      :rainYest,
      :rainMonth,
      :rainYear,
    ])
    |> validate_required([
      :dateTime,
      :tempOutCur,
      :humOutCur,
      :pressCur,
      :dewCur,
      :heatIdxCur,
      :windChillCur,
      :tempInCur,
      :humInCur,
      :windSpeedCur,
      :windAvgSpeedCur,
      :windDirCur,
      :windDirCurEng,
      :windGust10,
      :windDirAvg10,
      :windDirAvg10Eng,
      :uVAvg10,
      :uVMax10,
      :solarRadAvg10,
      :solarRadMax10,
      :rainRateCur,
      :rainDay,
      :rainYest,
      :rainMonth,
      :rainYear,
    ])
  end

end
