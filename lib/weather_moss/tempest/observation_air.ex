defmodule WeatherMoss.Tempest.ObservationAir do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_observation_air" do
    field :timestamp, :utc_datetime
    field :hub_sn, :string
    field :serial_number, :string
    field :station_pressure_MB, :float
    field :air_temperature_C, :float
    field :relative_humidity_percent, :integer
    field :lightningstrike_count, :integer
    field :lightningstrike_avg_distance_km, :integer
    field :battery_volts, :float
    field :reportinterval_minutes, :integer
  end

  @doc false
  def changeset(observation_air, attrs) do
    observation_air
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp, :station_pressure_MB, :air_temperature_C, :relative_humidity_percent, :lightningstrike_count, :lightningstrike_avg_distance_km, :battery])
    |> validate_required([:hub_sn, :serial_number, :timestamp, :station_pressure_MB, :air_temperature_C, :relative_humidity_percent, :lightningstrike_count, :lightningstrike_avg_distance_km, :battery])
  end
end
