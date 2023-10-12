defmodule WeatherMoss.Repo.Migrations.CreatePurpleAirObservation do
  use Ecto.Migration

  def change do
    create table(:purple_air_observation) do
      add :SensorId, :string
      add :DateTime, :utc_datetime
      add :rssi, :integer
      add :current_temp_f, :float
      add :current_humidity, :float
      add :current_dewpoint_f, :float
      add :pressure, :float
      add :current_temp_f_680, :float
      add :current_humidity_680, :float
      add :current_dewpoint_f_680, :float
      add :pressure_680, :float
      add :gas_680, :float
      add :p25aqic, :string
      add :p25aqic_b, :string
      add :pm2_5_aqi, :float
      add :pm2_5_aqi_b, :float
      add :pm1_0_cf_1, :float
      add :pm2_5_cf_1, :float
      add :pm10_0_cf_1, :float
      add :pm1_0_atm, :float
      add :pm2_5_atm, :float
      add :pm10_0_atm, :float
      add :p_0_3_um, :float
      add :p_0_5_um, :float
      add :p_1_0_um, :float
      add :p_2_5_um, :float
      add :p_5_0_um, :float
      add :p_10_0_um, :float
      add :pm1_0_cf_1_b, :float
      add :pm2_5_cf_1_b, :float
      add :pm10_0_cf_1_b, :float
      add :pm1_0_atm_b, :float
      add :pm2_5_atm_b, :float
      add :pm10_0_atm_b, :float
      add :p_0_3_um_b, :float
      add :p_0_5_um_b, :float
      add :p_1_0_um_b, :float
      add :p_2_5_um_b, :float
      add :p_5_0_um_b, :float
      add :p_10_0_um_b, :float

      timestamps()
    end
  end
end
