defmodule WeatherMoss.Tempest.RapidWind do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_rapid_wind" do
    field :hub_sn, :string
    field :serial_number, :string
    field :timestamp, :utc_datetime
    field :wind_speed_mps, :float
    field :wind_direction_degrees, :integer
  end

  @doc false
  def changeset(rapid_wind, attrs) do
    rapid_wind
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp, :wind_speed_mps, :wind_direction_degrees])
    |> validate_required([:hub_sn, :serial_number, :timestamp, :wind_speed_mps, :wind_direction_degrees])
  end
end
