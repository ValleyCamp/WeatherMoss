defmodule WeatherMoss.Repo.Migrations.CreateTempestObservationAir do
  use Ecto.Migration

  def change do
    create table(:tempest_observation_air) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
      add :station_pressure_MB, :float
      add :air_temperature_C, :float
      add :relative_humidity_percent, :integer
      add :lightningstrike_count, :integer
      add :lightningstrike_avg_distance_km, :integer
      add :battery_volts, :float
      add :reportinterval_minutes, :integer
    end

    create index(:tempest_observation_air, [:hub_sn, :timestamp])
  end
end
