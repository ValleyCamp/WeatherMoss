defmodule WeatherMossWeb.StartOfDayObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.StartOfDayObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, _params) do
    meteobridge_start_of_day_observations = Meteobridge.list_meteobridge_start_of_day_observations()
    render(conn, :index, meteobridge_start_of_day_observations: meteobridge_start_of_day_observations)
  end

  def create(conn, %{"start_of_day_observation" => start_of_day_observation_params}) do
    with {:ok, %StartOfDayObservation{} = start_of_day_observation} <- Meteobridge.create_start_of_day_observation(start_of_day_observation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/meteobridge_start_of_day_observations/#{start_of_day_observation}")
      |> render(:show, start_of_day_observation: start_of_day_observation)
    end
  end

  def show(conn, %{"id" => id}) do
    start_of_day_observation = Meteobridge.get_start_of_day_observation!(id)
    render(conn, :show, start_of_day_observation: start_of_day_observation)
  end
end
