defmodule WeatherMoss.Repo.Migrations.CreateMeteobridgeEndOfDayObservations do
  use Ecto.Migration

  def change do
    create table(:meteobridge_end_of_day_observations) do
      add :station, :string
      add :max_temp_F, :float
      add :min_temp_F, :float
      add :max_rain_rate_in, :float
      add :min_rain_rate_in, :float
      add :max_wind_gust_mph, :float
      add :max_solar_rad_wm2, :float

      timestamps()
    end

    create index(:meteobridge_end_of_day_observations, [:station, :inserted_at])
  end
end
