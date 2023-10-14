defmodule WeatherMossWeb.StartOfDayObservationControllerTest do
  use WeatherMossWeb.ConnCase

  import WeatherMoss.MeteobridgeFixtures

  alias WeatherMoss.Meteobridge.StartOfDayObservation

  @create_attrs %{
    station: "some station",
    rain_total_yesterday_in: 120.5,
    rain_total_month_in: 120.5,
    rain_total_year_in: 120.5,
    solar_max_possible: 120.5,
    astronomical_sunrise: ~N[2023-10-13 13:53:00],
    astronomical_sunset: ~N[2023-10-13 13:53:00]
  }
  @update_attrs %{
    station: "some updated station",
    rain_total_yesterday_in: 456.7,
    rain_total_month_in: 456.7,
    rain_total_year_in: 456.7,
    solar_max_possible: 456.7,
    astronomical_sunrise: ~N[2023-10-14 13:53:00],
    astronomical_sunset: ~N[2023-10-14 13:53:00]
  }
  @invalid_attrs %{station: nil, rain_total_yesterday_in: nil, rain_total_month_in: nil, rain_total_year_in: nil, solar_max_possible: nil, astronomical_sunrise: nil, astronomical_sunset: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all meteobridge_start_of_day_observations", %{conn: conn} do
      conn = get(conn, ~p"/api/meteobridge_start_of_day_observations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create start_of_day_observation" do
    test "renders start_of_day_observation when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_start_of_day_observations", start_of_day_observation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/meteobridge_start_of_day_observations/#{id}")

      assert %{
               "id" => ^id,
               "astronomical_sunrise" => "2023-10-13T13:53:00",
               "astronomical_sunset" => "2023-10-13T13:53:00",
               "rain_total_month_in" => 120.5,
               "rain_total_year_in" => 120.5,
               "rain_total_yesterday_in" => 120.5,
               "solar_max_possible" => 120.5,
               "station" => "some station"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_start_of_day_observations", start_of_day_observation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_start_of_day_observation(_) do
    start_of_day_observation = start_of_day_observation_fixture()
    %{start_of_day_observation: start_of_day_observation}
  end
end
