defmodule WeatherMoss.PurpleAir.Observation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "purple_air_observation" do
    field :SensorId, :string
    field :DateTime, :utc_datetime
    field :rssi, :integer
    field :current_temp_f, :float
    field :current_humidity, :float
    field :current_dewpoint_f, :float
    field :pressure, :float
    field :current_temp_f_680, :float
    field :current_humidity_680, :float
    field :current_dewpoint_f_680, :float
    field :pressure_680, :float
    field :gas_680, :float
    field :p25aqic, :string
    field :p25aqic_b, :string
    field :pm2_5_aqi, :float
    field :pm2_5_aqi_b, :float
    field :pm1_0_cf_1, :float
    field :pm2_5_cf_1, :float
    field :pm10_0_cf_1, :float
    field :pm1_0_atm, :float
    field :pm2_5_atm, :float
    field :pm10_0_atm, :float
    field :p_0_3_um, :float
    field :p_0_5_um, :float
    field :p_1_0_um, :float
    field :p_2_5_um, :float
    field :p_5_0_um, :float
    field :p_10_0_um, :float
    field :pm1_0_cf_1_b, :float
    field :pm2_5_cf_1_b, :float
    field :pm10_0_cf_1_b, :float
    field :pm1_0_atm_b, :float
    field :pm2_5_atm_b, :float
    field :pm10_0_atm_b, :float
    field :p_0_3_um_b, :float
    field :p_0_5_um_b, :float
    field :p_1_0_um_b, :float
    field :p_2_5_um_b, :float
    field :p_5_0_um_b, :float
    field :p_10_0_um_b, :float

    timestamps()
  end

  @doc false
  def changeset(observation, attrs) do
    observation
    |> cast(attrs, [:SensorId, :DateTime, :rssi, :current_temp_f, :current_humidity, :current_dewpoint_f, :pressure, :current_temp_f_680, :current_humidity_680, :current_dewpoint_f_680, :pressure_680, :gas_680, :p25aqic, :p25aqic_b, :pm2_5_aqi, :pm2_5_aqi_b, :pm1_0_cf_1, :pm2_5_cf_1, :pm10_0_cf_1, :pm1_0_atm, :pm2_5_atm, :pm10_0_atm, :p_0_3_um, :p_0_5_um, :p_1_0_um, :p_2_5_um, :p_5_0_um, :p_10_0_um, :pm1_0_cf_1_b, :pm2_5_cf_1_b, :pm10_0_cf_1_b, :pm1_0_atm_b, :pm2_5_atm_b, :pm10_0_atm_b, :p_0_3_um_b, :p_0_5_um_b, :p_1_0_um_b, :p_2_5_um_b, :p_5_0_um_b, :p_10_0_um_b])
    |> validate_required([:SensorId, :DateTime, :rssi, :current_temp_f, :current_humidity, :current_dewpoint_f, :pressure, :current_temp_f_680, :current_humidity_680, :current_dewpoint_f_680, :pressure_680, :gas_680, :p25aqic, :p25aqic_b, :pm2_5_aqi, :pm2_5_aqi_b, :pm1_0_cf_1, :pm2_5_cf_1, :pm10_0_cf_1, :pm1_0_atm, :pm2_5_atm, :pm10_0_atm, :p_0_3_um, :p_0_5_um, :p_1_0_um, :p_2_5_um, :p_5_0_um, :p_10_0_um, :pm1_0_cf_1_b, :pm2_5_cf_1_b, :pm10_0_cf_1_b, :pm1_0_atm_b, :pm2_5_atm_b, :pm10_0_atm_b, :p_0_3_um_b, :p_0_5_um_b, :p_1_0_um_b, :p_2_5_um_b, :p_5_0_um_b, :p_10_0_um_b])
  end
end
