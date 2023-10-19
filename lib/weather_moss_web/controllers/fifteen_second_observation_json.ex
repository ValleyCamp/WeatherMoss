defmodule WeatherMossWeb.FifteenSecondObservationJSON do
  alias WeatherMoss.Meteobridge.FifteenSecondObservation

  @doc """
  Renders a list of meteobridge_fifteen_second_observations.
  """
  def index(%{meteobridge_fifteen_second_observations: meteobridge_fifteen_second_observations}) do
    for(fifteen_second_observation <- meteobridge_fifteen_second_observations, do: data(fifteen_second_observation))
  end

  @doc """
  Renders a single fifteen_second_observation.
  """
  def show(%{fifteen_second_observation: fifteen_second_observation}) do
    data(fifteen_second_observation)
  end

  defp data(%FifteenSecondObservation{} = fifteen_second_observation) do
    %{
      id: fifteen_second_observation.id,
      station: fifteen_second_observation.station,
      inserted_at: fifteen_second_observation.inserted_at,
      temp_act_F: fifteen_second_observation.temp_act_F,
      rain_rate_act_in: fifteen_second_observation.rain_rate_act_in,
      rain_total_day_in: fifteen_second_observation.rain_total_day_in,
      wind_dir_act: fifteen_second_observation.wind_dir_act,
      wind_dir_act_en: fifteen_second_observation.wind_dir_act_en,
      wind_speed_act_mph: fifteen_second_observation.wind_speed_act_mph,
      solar_rad_act_wm2: fifteen_second_observation.solar_rad_act_wm2,
      uv_index: fifteen_second_observation.uv_index
    }
  end
end
