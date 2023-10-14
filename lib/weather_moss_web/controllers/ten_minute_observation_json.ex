defmodule WeatherMossWeb.TenMinuteObservationJSON do
  alias WeatherMoss.Meteobridge.TenMinuteObservation

  @doc """
  Renders a list of meteobridge_ten_minute_observations.
  """
  def index(%{meteobridge_ten_minute_observations: meteobridge_ten_minute_observations}) do
    %{data: for(ten_minute_observation <- meteobridge_ten_minute_observations, do: data(ten_minute_observation))}
  end

  @doc """
  Renders a single ten_minute_observation.
  """
  def show(%{ten_minute_observation: ten_minute_observation}) do
    %{data: data(ten_minute_observation)}
  end

  defp data(%TenMinuteObservation{} = ten_minute_observation) do
    %{
      id: ten_minute_observation.id,
      station: ten_minute_observation.station,
      inserted_at: ten_minute_observation.inserted_at,
      indoor_temp_avg_F: ten_minute_observation.indoor_temp_avg_F,
      indoor_humidity_act: ten_minute_observation.indoor_humidity_act,
      indoor_dewpoint_act_F: ten_minute_observation.indoor_dewpoint_act_F,
      temp_avg_F: ten_minute_observation.temp_avg_F,
      humidity_act: ten_minute_observation.humidity_act,
      dewpoint_act_F: ten_minute_observation.dewpoint_act_F,
      heatindex_act_F: ten_minute_observation.heatindex_act_F,
      pressure_act_hPa: ten_minute_observation.pressure_act_hPa,
      pressure_sealevel_act_inHg: ten_minute_observation.pressure_sealevel_act_inHg,
      wind_chill_act_F: ten_minute_observation.wind_chill_act_F,
      wind_speed_act_mph: ten_minute_observation.wind_speed_act_mph,
      wind_speed_average_mph: ten_minute_observation.wind_speed_average_mph,
      wind_speed_avg10_mph: ten_minute_observation.wind_speed_avg10_mph,
      wind_speed_max_mph: ten_minute_observation.wind_speed_max_mph,
      wind_dir_act: ten_minute_observation.wind_dir_act,
      wind_dir_act_en: ten_minute_observation.wind_dir_act_en,
      wind_dir_avg: ten_minute_observation.wind_dir_avg,
      wind_dir_avg_en: ten_minute_observation.wind_dir_avg_en,
      uv_index_avg: ten_minute_observation.uv_index_avg,
      uv_index_max: ten_minute_observation.uv_index_max,
      solar_rad_avg_wm2: ten_minute_observation.solar_rad_avg_wm2,
      solar_rad_max_wm2: ten_minute_observation.solar_rad_max_wm2,
      lightning_distance_avg_miles: ten_minute_observation.lightning_distance_avg_miles,
      lightning_energy_avg: ten_minute_observation.lightning_energy_avg,
      lightning_energy_max: ten_minute_observation.lightning_energy_max,
      lightning_strike_count: ten_minute_observation.lightning_strike_count,
      rain_rate_act_in: ten_minute_observation.rain_rate_act_in,
      rain_total_day_in: ten_minute_observation.rain_total_day_in
    }
  end
end
