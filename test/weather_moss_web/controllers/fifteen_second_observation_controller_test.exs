defmodule WeatherMossWeb.FifteenSecondObservationControllerTest do
  use WeatherMossWeb.ConnCase

  import WeatherMoss.MeteobridgeFixtures

  alias WeatherMoss.Meteobridge.FifteenSecondObservation

  @create_attrs %{
    station: "some station",
    temp_act_F: 120.5,
    rain_rate_act_in: 120.5,
    rain_total_day_in: 120.5,
    wind_dir_act: 42,
    wind_dir_act_en: "some wind_dir_act_en",
    wind_speed_act_mph: 120.5,
    solar_rad_act_wm2: 120.5,
    uv_index: 120.5
  }
  @update_attrs %{
    station: "some updated station",
    temp_act_F: 456.7,
    rain_rate_act_in: 456.7,
    rain_total_day_in: 456.7,
    wind_dir_act: 43,
    wind_dir_act_en: "some updated wind_dir_act_en",
    wind_speed_act_mph: 456.7,
    solar_rad_act_wm2: 456.7,
    uv_index: 456.7
  }
  @invalid_attrs %{station: nil, temp_act_F: nil, rain_rate_act_in: nil, rain_total_day_in: nil, wind_dir_act: nil, wind_dir_act_en: nil, wind_speed_act_mph: nil, solar_rad_act_wm2: nil, uv_index: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all meteobridge_fifteen_second_observations", %{conn: conn} do
      conn = get(conn, ~p"/api/meteobridge_fifteen_second_observations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create fifteen_second_observation" do
    test "renders fifteen_second_observation when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_fifteen_second_observations", fifteen_second_observation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/meteobridge_fifteen_second_observations/#{id}")

      assert %{
               "id" => ^id,
               "rain_total_day_in" => 120.5,
               "rain_rate_act_in" => 120.5,
               "solar_rad_act_wm2" => 120.5,
               "station" => "some station",
               "temp_act_F" => 120.5,
               "uv_index" => 120.5,
               "wind_dir_act" => 42,
               "wind_dir_act_en" => "some wind_dir_act_en",
               "wind_speed_act_mph" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_fifteen_second_observations", fifteen_second_observation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_fifteen_second_observation(_) do
    fifteen_second_observation = fifteen_second_observation_fixture()
    %{fifteen_second_observation: fifteen_second_observation}
  end
end
