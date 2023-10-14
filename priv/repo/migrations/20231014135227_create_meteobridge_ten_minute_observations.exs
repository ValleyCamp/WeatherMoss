defmodule WeatherMoss.Repo.Migrations.CreateMeteobridgeTenMinuteObservations do
  use Ecto.Migration

  def change do
    create table(:meteobridge_ten_minute_observations) do
      add :station, :string
      add :indoor_temp_avg_F, :float
      add :indoor_humidity_act, :float
      add :indoor_dewpoint_act_F, :float
      add :temp_avg_F, :float
      add :humidity_act, :float
      add :dewpoint_act_F, :float
      add :heatindex_act_F, :float
      add :pressure_act_hPa, :float
      add :pressure_sealevel_act_inHg, :float
      add :wind_chill_act_F, :float
      add :wind_speed_act_mph, :float
      add :wind_speed_average_mph, :float
      add :wind_speed_avg10_mph, :float
      add :wind_speed_max_mph, :float
      add :wind_dir_act, :float
      add :wind_dir_act_en, :string
      add :wind_dir_avg, :float
      add :wind_dir_avg_en, :string
      add :uv_index_avg, :float
      add :uv_index_max, :float
      add :solar_rad_avg_wm2, :float
      add :solar_rad_max_wm2, :float
      add :lightning_distance_avg_miles, :float
      add :lightning_energy_avg, :float
      add :lightning_energy_max, :float
      add :lightning_strike_count, :integer
      add :rain_rate_act_in, :float
      add :rain_total_day_in, :float

      timestamps()
    end

    create index(:meteobridge_ten_minute_observations, [:station, :inserted_at])
  end
end
