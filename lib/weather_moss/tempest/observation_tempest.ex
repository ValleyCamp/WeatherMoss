defmodule WeatherMoss.Tempest.ObservationTempest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_observation_tempest" do
    field :timestamp, :utc_datetime
    field :hub_sn, :string
    field :serial_number, :string
    field :wind_lull_ms, :float
    field :wind_avg_ms, :float
    field :wind_gust_ms, :float
    field :wind_direction_degrees, :integer
    field :wind_sample_interval_seconds, :integer
    field :station_pressure_MB, :float
    field :air_temperature_C, :float
    field :relative_humidity_percent, :float
    field :illuminance_lux, :integer
    field :uv_index, :float
    field :solar_radiation_wm2, :integer
    field :precip_accumulated_mm, :float
    field :precipitation_type, Ecto.Enum, values: [:none, :rain, :hail, :rain_plus_hail]
    field :lightningstrike_avg_distance_km, :integer
    field :lightningstrike_count, :integer
    field :battery_volts, :float
    field :reportinterval_minutes, :integer

    timestamps()
  end

  @doc false
  def changeset(observation_tempest, attrs) do
    observation_tempest
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp, :wind_lull_ms, :wind_avg_ms, :wind_gust_ms, :wind_direction_degrees, :wind_sample_interval_seconds, :station_pressure_MB, :air_temperature_C, :relative_humidity_percent, :illuminance_lux, :uv_index, :solar_radiation_wm2, :precip_accumulated_mm, :precipitation_type, :lightningstrike_avg_distance_km, :lightningstrike_count, :battery_volts, :reportinterval_minutes])
    |> validate_required([:hub_sn, :serial_number, :timestamp, :wind_lull_ms, :wind_avg_ms, :wind_gust_ms, :wind_direction_degrees, :wind_sample_interval_seconds, :station_pressure_MB, :air_temperature_C, :relative_humidity_percent, :illuminance_lux, :uv_index, :solar_radiation_wm2, :precip_accumulated_mm, :precipitation_type, :lightningstrike_avg_distance_km, :lightningstrike_count, :battery_volts, :reportinterval_minutes])
  end
end
