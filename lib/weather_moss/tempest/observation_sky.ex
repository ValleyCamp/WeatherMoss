defmodule WeatherMoss.Tempest.ObservationSky do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_observation_sky" do
    field :timestamp, :utc_datetime
    field :hub_sn, :string
    field :serial_number, :string
    field :illuminance_lux, :integer
    field :uv_index, :integer
    field :rain_accumulated_mm, :float
    field :wind_lull_ms, :float
    field :wing_avg_ms, :float
    field :wind_gust_ms, :float
    field :wind_direction_degrees, :integer
    field :solar_radiation_wm2, :integer
    field :local_day_rain_accumulation_mm, :float
    field :precipitation_type, Ecto.Enum, values: [:none, :rain, :hail, :rain_plus_hail]
    field :wind_sample_interval_seconds, :integer
    field :battery_volts, :float
    field :reportinterval_minutes, :integer
  end

  @doc false
  def changeset(observation_sky, attrs) do
    observation_sky
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp, :illuminance_lux, :uv_index, :rain_accumulated_mm, :wind_lull_ms, :wing_avg_ms, :wind_gust_ms, :wind_direction_degrees, :solar_radiation_wm2, :local_day_rain_accumulation_mm, :precipitation_type, :wind_sample_interval_seconds, :battery_volts])
    |> validate_required([:hub_sn, :serial_number, :timestamp, :illuminance_lux, :uv_index, :rain_accumulated_mm, :wind_lull_ms, :wing_avg_ms, :wind_gust_ms, :wind_direction_degrees, :solar_radiation_wm2, :local_day_rain_accumulation_mm, :precipitation_type, :wind_sample_interval_seconds, :battery_volts])
  end
end
