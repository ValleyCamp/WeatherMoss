defmodule WeatherMossWeb.TenMinuteObservationController do
  use WeatherMossWeb, :controller

  alias WeatherMoss.Meteobridge
  alias WeatherMoss.Meteobridge.TenMinuteObservation

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, params) do
    meteobridge_ten_minute_observations = Meteobridge.recent_ten_minute_observations(params["station"])
    render(conn, :index, meteobridge_ten_minute_observations: meteobridge_ten_minute_observations)
  end

  # Note that we do *absolutely no* authorization checking here.
  # Anyone who understands the correct URL structure could theoretically feed us bad data...
  def new(conn, params) do
    with {:ok, %TenMinuteObservation{} = saved} <- Meteobridge.create_ten_minute_observation(params) do
      conn
      |> put_status(:created)
      |> json(%{status: "saved", id: saved.id})
    end
  end

  def show(conn, %{"id" => id}) do
    ten_minute_observation = Meteobridge.get_ten_minute_observation!(id)
    render(conn, :show, ten_minute_observation: ten_minute_observation)
  end
end
