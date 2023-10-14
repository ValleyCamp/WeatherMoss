defmodule WeatherMossWeb.EndOfDayObservationControllerTest do
  use WeatherMossWeb.ConnCase

  import WeatherMoss.MeteobridgeFixtures

  alias WeatherMoss.Meteobridge.EndOfDayObservation

  @create_attrs %{
    station: "some station",
    max_temp_F: 120.5,
    min_temp_F: 120.5,
    max_rain_rate_in: 120.5,
    min_rain_rate_in: 120.5,
    max_wind_gust_mph: 120.5,
    max_solar_rad_wm2: 120.5
  }
  @update_attrs %{
    station: "some updated station",
    max_temp_F: 456.7,
    min_temp_F: 456.7,
    max_rain_rate_in: 456.7,
    min_rain_rate_in: 456.7,
    max_wind_gust_mph: 456.7,
    max_solar_rad_wm2: 456.7
  }
  @invalid_attrs %{station: nil, max_temp_F: nil, min_temp_F: nil, max_rain_rate_in: nil, min_rain_rate_in: nil, max_wind_gust_mph: nil, max_solar_rad_wm2: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all meteobridge_end_of_day_observations", %{conn: conn} do
      conn = get(conn, ~p"/api/meteobridge/end_of_day")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create end_of_day_observation" do
    test "renders end_of_day_observation when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge/end_of_day", end_of_day_observation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/meteobridge/end_of_day/#{id}")

      assert %{
               "id" => ^id,
               "max_rain_rate_in" => 120.5,
               "max_solar_rad_wm2" => 120.5,
               "max_temp_F" => 120.5,
               "max_wind_gust_mph" => 120.5,
               "min_rain_rate_in" => 120.5,
               "min_temp_F" => 120.5,
               "station" => "some station"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge/end_of_day", end_of_day_observation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_end_of_day_observation(_) do
    end_of_day_observation = end_of_day_observation_fixture()
    %{end_of_day_observation: end_of_day_observation}
  end
end
