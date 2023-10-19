defmodule WeatherMossWeb.StartOfDayObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.StartOfDayObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, params) do
    meteobridge_start_of_day_observations = Meteobridge.recent_start_of_day_observations(params["station"])
    render(conn, :index, meteobridge_start_of_day_observations: meteobridge_start_of_day_observations)
  end

  def new(conn, params) do
    with {:ok, %StartOfDayObservation{} = saved} <- Meteobridge.create_start_of_day_observation(params) do
      conn
      |> put_status(:created)
      |> json(%{status: "saved", id: saved.id})
    end
  end

  def show(conn, %{"id" => id}) do
    start_of_day_observation = Meteobridge.get_start_of_day_observation!(id)
    render(conn, :show, start_of_day_observation: start_of_day_observation)
  end
end
