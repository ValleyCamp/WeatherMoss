defmodule WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  # The SQL Query we use to insert this data from the Meteobridge services interface:
  # INSERT INTO `housestation_15sec_raintemp` (`DateTime`, `TempOutCur`, `RainRateCur`, `RainDay`) VALUES ('[YYYY]-[MM]-[DD] [hh]:[mm]:[ss]', '[th0temp-act=F]', '[rain0rate-act=in.2]', '[rain0total-daysum=in.2]')
  schema "housestation_15sec_raintemp" do
    field :dateTime, :utc_datetime
    field :tempOutCur, :decimal
    field :rainRateCur, :decimal
    field :rainDay, :decimal
  end
end
