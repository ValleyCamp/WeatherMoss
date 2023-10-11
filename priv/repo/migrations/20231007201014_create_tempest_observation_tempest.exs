defmodule WeatherMoss.Repo.Migrations.CreateTempestObservationTempest do
  use Ecto.Migration

  def change do
    create table(:tempest_observation_tempest) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
      add :wind_lull_ms, :float
      add :wind_avg_ms, :float
      add :wind_gust_ms, :float
      add :wind_direction_degrees, :integer
      add :wind_sample_interval_seconds, :integer
      add :station_pressure_MB, :float
      add :air_temperature_C, :float
      add :relative_humidity_percent, :float
      add :illuminance_lux, :integer
      add :uv_index, :float
      add :solar_radiation_wm2, :integer
      add :precip_accumulated_mm, :float
      add :precipitation_type, :string
      add :lightningstrike_avg_distance_km, :integer
      add :lightningstrike_count, :integer
      add :battery_volts, :float
      add :reportinterval_minutes, :integer
    end

    create index(:tempest_observation_tempest, [:hub_sn, :timestamp])
  end
end
