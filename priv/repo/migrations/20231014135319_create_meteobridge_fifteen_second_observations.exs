defmodule WeatherMoss.Repo.Migrations.CreateMeteobridgeFifteenSecondObservations do
  use Ecto.Migration

  def change do
    create table(:meteobridge_fifteen_second_observations) do
      add :station, :string
      add :temp_act_F, :float
      add :rain_rate_act_in, :float
      add :rain_total_day_in, :float
      add :wind_dir_act, :integer
      add :wind_dir_act_en, :string
      add :wind_speed_act_mph, :float
      add :solar_rad_act_wm2, :float
      add :uv_index, :float

      timestamps()
    end

    create index(:meteobridge_fifteen_second_observations, [:station, :inserted_at])
  end
end
