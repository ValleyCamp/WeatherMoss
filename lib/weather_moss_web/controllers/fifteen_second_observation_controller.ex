defmodule WeatherMossWeb.FifteenSecondObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.FifteenSecondObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, params) do
    meteobridge_fifteen_second_observations = Meteobridge.recent_fifteen_second_observations(params["station"])
    render(conn, :index, meteobridge_fifteen_second_observations: meteobridge_fifteen_second_observations)
  end

  # Note that we do *absolutely no* authorization checking here.
  # Anyone who understands the correct URL structure could theoretically feed us bad data...
  def new(conn, params) do
    with {:ok, %FifteenSecondObservation{} = saved} <- Meteobridge.create_fifteen_second_observation(params) do
      conn
      |> put_status(:created)
      |> json(%{status: "saved", id: saved.id})
    end
  end

  def show(conn, %{"id" => id}) do
    fifteen_second_observation = Meteobridge.get_fifteen_second_observation!(id)
    render(conn, :show, fifteen_second_observation: fifteen_second_observation)
  end
end
