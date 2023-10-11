defmodule WeatherMoss.Repo.Migrations.CreateTempestRapidWind do
  use Ecto.Migration

  def change do
    create table(:tempest_rapid_wind) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
      add :wind_speed_mps, :float
      add :wind_direction_degrees, :integer
    end

    create index(:tempest_rapid_wind, [:hub_sn, :timestamp])
  end
end
