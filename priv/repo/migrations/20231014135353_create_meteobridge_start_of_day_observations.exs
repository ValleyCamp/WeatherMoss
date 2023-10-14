defmodule WeatherMoss.Repo.Migrations.CreateMeteobridgeStartOfDayObservations do
  use Ecto.Migration

  def change do
    create table(:meteobridge_start_of_day_observations) do
      add :station, :string
      add :rain_total_yesterday_in, :float
      add :rain_total_month_in, :float
      add :rain_total_year_in, :float
      add :solar_max_possible, :float
      add :astronomical_sunrise, :naive_datetime
      add :astronomical_sunset, :naive_datetime

      timestamps()
    end

    create index(:meteobridge_start_of_day_observations, [:station, :inserted_at])
  end
end
