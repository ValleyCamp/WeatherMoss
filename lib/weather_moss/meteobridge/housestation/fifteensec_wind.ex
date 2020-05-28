defmodule WeatherMoss.Meteobridge.Housestation.FifteensecondWind do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "housestation_15sec_wind" do
    field :dateTime, :utc_datetime
    field :windDirCur, :integer
    field :windDirCurEng, :string
    field :windSpeedCur, :decimal
  end
end
