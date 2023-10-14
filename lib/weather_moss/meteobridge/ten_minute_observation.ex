defmodule WeatherMoss.Meteobridge.TenMinuteObservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meteobridge_ten_minute_observations" do
    field :station, :string
    field :indoor_temp_avg_F, :float
    field :indoor_humidity_act, :float
    field :indoor_dewpoint_act_F, :float
    field :temp_avg_F, :float
    field :humidity_act, :float
    field :dewpoint_act_F, :float
    field :heatindex_act_F, :float
    field :pressure_act_hPa, :float
    field :pressure_sealevel_act_inHg, :float
    field :wind_chill_act_F, :float
    field :wind_speed_act_mph, :float
    field :wind_speed_average_mph, :float
    field :wind_speed_avg10_mph, :float
    field :wind_speed_max_mph, :float
    field :wind_dir_act, :float
    field :wind_dir_act_en, :string
    field :wind_dir_avg, :float
    field :wind_dir_avg_en, :string
    field :uv_index_avg, :float
    field :uv_index_max, :float
    field :solar_rad_avg_wm2, :float
    field :solar_rad_max_wm2, :float
    field :lightning_distance_avg_miles, :float
    field :lightning_energy_avg, :float
    field :lightning_energy_max, :float
    field :lightning_strike_count, :integer
    field :rain_rate_act_in, :float
    field :rain_total_day_in, :float

    timestamps()
  end

  @doc false
  def changeset(ten_minute_observation, attrs) do
    ten_minute_observation
    |> cast(attrs, [:station, :indoor_temp_avg_F, :indoor_humidity_act, :indoor_dewpoint_act_F, :temp_avg_F, :humidity_act, :dewpoint_act_F, :heatindex_act_F, :pressure_act_hPa, :pressure_sealevel_act_inHg, :wind_chill_act_F, :wind_speed_act_mph, :wind_speed_average_mph, :wind_speed_avg10_mph, :wind_speed_max_mph, :wind_dir_act, :wind_dir_act_en, :wind_dir_avg, :wind_dir_avg_en, :uv_index_avg, :uv_index_max, :solar_rad_avg_wm2, :solar_rad_max_wm2, :lightning_distance_avg_miles, :lightning_energy_avg, :lightning_energy_max, :lightning_strike_count, :rain_rate_act_in, :rain_total_day_in])
    |> validate_required([:station, :indoor_temp_avg_F, :indoor_humidity_act, :indoor_dewpoint_act_F, :temp_avg_F, :humidity_act, :dewpoint_act_F, :heatindex_act_F, :pressure_act_hPa, :pressure_sealevel_act_inHg, :wind_chill_act_F, :wind_speed_act_mph, :wind_speed_average_mph, :wind_speed_avg10_mph, :wind_speed_max_mph, :wind_dir_act, :wind_dir_act_en, :wind_dir_avg, :wind_dir_avg_en, :uv_index_avg, :uv_index_max, :solar_rad_avg_wm2, :solar_rad_max_wm2, :lightning_distance_avg_miles, :lightning_energy_avg, :lightning_energy_max, :lightning_strike_count, :rain_rate_act_in, :rain_total_day_in])
  end
end
