defmodule WeatherMossWeb.EndOfDayObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.EndOfDayObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, params) do
    meteobridge_end_of_day_observations = Meteobridge.recent_end_of_day_observations(params["station"])
    render(conn, :index, meteobridge_end_of_day_observations: meteobridge_end_of_day_observations)
  end

  def new(conn, params) do
    with {:ok, %EndOfDayObservation{} = saved} <- Meteobridge.create_end_of_day_observation(params) do
      conn
      |> put_status(:created)
      |> json(%{status: "saved", id: saved.id})
    end
  end

  def show(conn, %{"id" => id}) do
    end_of_day_observation = Meteobridge.get_end_of_day_observation!(id)
    render(conn, :show, end_of_day_observation: end_of_day_observation)
  end
end
