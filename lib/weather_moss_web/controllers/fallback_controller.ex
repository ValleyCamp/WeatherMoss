defmodule WeatherMossWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WeatherMossWeb, :controller
  require Logger

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: WeatherMossWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: WeatherMossWeb.ErrorHTML, json: WeatherMossWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, err) do
    Logger.error("FallbackController handling an unknown error!\n\tError was: #{inspect err}\n\tConn was:#{inspect conn}")
    conn
    |> put_status(:bad_request)
    |> json(%{status: "error", error: "#{inspect err}"})
  end

end
