defmodule WeatherMossWeb.FifteenSecondObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.FifteenSecondObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, _params) do
    meteobridge_fifteen_second_observations = Meteobridge.list_meteobridge_fifteen_second_observations()
    render(conn, :index, meteobridge_fifteen_second_observations: meteobridge_fifteen_second_observations)
  end

  def create(conn, %{"fifteen_second_observation" => fifteen_second_observation_params}) do
    with {:ok, %FifteenSecondObservation{} = fifteen_second_observation} <- Meteobridge.create_fifteen_second_observation(fifteen_second_observation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/meteobridge_fifteen_second_observations/#{fifteen_second_observation}")
      |> render(:show, fifteen_second_observation: fifteen_second_observation)
    end
  end

  def show(conn, %{"id" => id}) do
    fifteen_second_observation = Meteobridge.get_fifteen_second_observation!(id)
    render(conn, :show, fifteen_second_observation: fifteen_second_observation)
  end
end
