defmodule WeatherMossWeb.EndOfDayObservationJSON do
  alias WeatherMoss.Meteobridge.EndOfDayObservation

  @doc """
  Renders a list of meteobridge_end_of_day_observations.
  """
  def index(%{meteobridge_end_of_day_observations: meteobridge_end_of_day_observations}) do
    for(end_of_day_observation <- meteobridge_end_of_day_observations, do: data(end_of_day_observation))
  end

  @doc """
  Renders a single end_of_day_observation.
  """
  def show(%{end_of_day_observation: end_of_day_observation}) do
    data(end_of_day_observation)
  end

  defp data(%EndOfDayObservation{} = end_of_day_observation) do
    %{
      id: end_of_day_observation.id,
      station: end_of_day_observation.station,
      inserted_at: end_of_day_observation.inserted_at,
      max_temp_F: end_of_day_observation.max_temp_F,
      min_temp_F: end_of_day_observation.min_temp_F,
      max_rain_rate_in: end_of_day_observation.max_rain_rate_in,
      min_rain_rate_in: end_of_day_observation.min_rain_rate_in,
      max_wind_gust_mph: end_of_day_observation.max_wind_gust_mph,
      max_solar_rad_wm2: end_of_day_observation.max_solar_rad_wm2
    }
  end
end
