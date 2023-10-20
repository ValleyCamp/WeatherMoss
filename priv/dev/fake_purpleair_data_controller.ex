defmodule WeatherMossWeb.FakePurpleairDataController do
  use WeatherMossWeb, :controller

  action_fallback WeatherMossWeb.FallbackController

  def index(conn, _params) do
    latest = case :ets.lookup(:purpleair_fakedata_cache, :latest) do
      [{:latest, data}] -> data
      [] -> %{error: "No cached data found"}
    end

    # Massage the formats we save data in to the formats that the Purple uses
    fixed_latest = latest
      |> Map.replace!(:DateTime, Timex.format!(latest[:DateTime], "{YYYY}/{0M}/{0D}T{h24}:{m}:{s}z"))

    conn
    |> json(fixed_latest)
  end
end
