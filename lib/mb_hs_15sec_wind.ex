defmodule WeatherMoss.MeteobridgeHousestationFifteensecondWind do
  use Ecto.Schema

  @primary_key {:ID, :id, autogenerate: true}

  schema "housestation_15sec_wind" do
    field :DateTime, :utc_datetime
    field :WindDirCur, :integer
    field :WindDirCurEng, :string
    field :WindSpeedCur, :decimal
  end
end
