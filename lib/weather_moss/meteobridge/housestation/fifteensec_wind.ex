defmodule WeatherMoss.Meteobridge.Housestation.FifteensecondWind do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  # The SQL Query we use to insert this data from the Meteobridge services interface:
  # INSERT INTO `housestation_15sec_wind` (`DateTime`, `WindDirCur`, `WindDirCurEng`, `WindSpeedCur`) VALUES ('[YYYY]-[MM]-[DD] [hh]:[mm]:[ss]', '[wind0dir-act]', '[wind0dir-act=endir]', '[wind0wind-act=mph]')
  schema "housestation_15sec_wind" do
    field :dateTime, :utc_datetime
    field :windDirCur, :integer
    field :windDirCurEng, :string
    field :windSpeedCur, :decimal
  end
end
