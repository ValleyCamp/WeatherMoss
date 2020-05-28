defmodule WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp do
  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}

  schema "housestation_15sec_raintemp" do
    field :dateTime, :utc_datetime
    field :tempOutCur, :decimal
    field :rainRateCur, :decimal
    field :rainDay, :decimal
  end
end
