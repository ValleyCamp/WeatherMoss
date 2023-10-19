defmodule WeatherMossWeb.StartOfDayObservationJSON do
  alias WeatherMoss.Meteobridge.StartOfDayObservation

  @doc """
  Renders a list of meteobridge_start_of_day_observations.
  """
  def index(%{meteobridge_start_of_day_observations: meteobridge_start_of_day_observations}) do
    for(start_of_day_observation <- meteobridge_start_of_day_observations, do: data(start_of_day_observation))
  end

  @doc """
  Renders a single start_of_day_observation.
  """
  def show(%{start_of_day_observation: start_of_day_observation}) do
    data(start_of_day_observation)
  end

  defp data(%StartOfDayObservation{} = start_of_day_observation) do
    %{
      id: start_of_day_observation.id,
      station: start_of_day_observation.station,
      inserted_at: start_of_day_observation.inserted_at,
      rain_total_yesterday_in: start_of_day_observation.rain_total_yesterday_in,
      rain_total_month_in: start_of_day_observation.rain_total_month_in,
      rain_total_year_in: start_of_day_observation.rain_total_year_in,
      solar_max_possible: start_of_day_observation.solar_max_possible,
      astronomical_sunrise: start_of_day_observation.astronomical_sunrise,
      astronomical_sunset: start_of_day_observation.astronomical_sunset
    }
  end
end
