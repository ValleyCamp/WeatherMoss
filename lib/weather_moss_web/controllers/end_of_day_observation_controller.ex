defmodule WeatherMossWeb.EndOfDayObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.EndOfDayObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, _params) do
    meteobridge_end_of_day_observations = Meteobridge.list_meteobridge_end_of_day_observations()
    render(conn, :index, meteobridge_end_of_day_observations: meteobridge_end_of_day_observations)
  end

  def create(conn, %{"end_of_day_observation" => end_of_day_observation_params}) do
    with {:ok, %EndOfDayObservation{} = end_of_day_observation} <- Meteobridge.create_end_of_day_observation(end_of_day_observation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/meteobridge_end_of_day_observations/#{end_of_day_observation}")
      |> render(:show, end_of_day_observation: end_of_day_observation)
    end
  end

  def show(conn, %{"id" => id}) do
    end_of_day_observation = Meteobridge.get_end_of_day_observation!(id)
    render(conn, :show, end_of_day_observation: end_of_day_observation)
  end
end
