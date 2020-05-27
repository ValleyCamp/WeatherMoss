defmodule WeatherMoss.MeteobridgeHousestationFifteensecondRainAndTemp do
  use Ecto.Schema

  @primary_key {:ID, :id, autogenerate: true}

  schema "housestation_15sec_raintemp" do
    field :DateTime, :utc_datetime
    field :TempOutCur, :decimal
    field :RainRateCur, :decimal
    field :RainDay, :decimal
  end
end
