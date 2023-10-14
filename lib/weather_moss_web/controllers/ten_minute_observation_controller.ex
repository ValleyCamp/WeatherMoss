defmodule WeatherMossWeb.TenMinuteObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.TenMinuteObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, _params) do
    meteobridge_ten_minute_observations = Meteobridge.list_meteobridge_ten_minute_observations()
    render(conn, :index, meteobridge_ten_minute_observations: meteobridge_ten_minute_observations)
  end

  def create(conn, %{"ten_minute_observation" => ten_minute_observation_params}) do
    with {:ok, %TenMinuteObservation{} = ten_minute_observation} <- Meteobridge.create_ten_minute_observation(ten_minute_observation_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/meteobridge_ten_minute_observations/#{ten_minute_observation}")
      |> render(:show, ten_minute_observation: ten_minute_observation)
    end
  end

  def show(conn, %{"id" => id}) do
    ten_minute_observation = Meteobridge.get_ten_minute_observation!(id)
    render(conn, :show, ten_minute_observation: ten_minute_observation)
  end
end
