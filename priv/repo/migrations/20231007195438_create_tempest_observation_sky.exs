defmodule WeatherMoss.Repo.Migrations.CreateTempestObservationSky do
  use Ecto.Migration

  def change do
    create table(:tempest_observation_sky) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
      add :illuminance_lux, :integer
      add :uv_index, :integer
      add :rain_accumulated_mm, :float
      add :wind_lull_ms, :float
      add :wing_avg_ms, :float
      add :wind_gust_ms, :float
      add :wind_direction_degrees, :integer
      add :solar_radiation_wm2, :integer
      add :local_day_rain_accumulation_mm, :float
      add :precipitation_type, :string
      add :wind_sample_interval_seconds, :integer
      add :battery_volts, :float
      add :reportinterval_minutes, :integer
    end


    create index(:tempest_observation_sky, [:hub_sn, :timestamp])
  end
end
