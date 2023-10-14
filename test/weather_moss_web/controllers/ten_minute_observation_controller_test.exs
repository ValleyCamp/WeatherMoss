defmodule WeatherMossWeb.TenMinuteObservationControllerTest do
  use WeatherMossWeb.ConnCase

  import WeatherMoss.MeteobridgeFixtures

  alias WeatherMoss.Meteobridge.TenMinuteObservation

  @create_attrs %{
    station: "some station",
    indoor_temp_avg_F: 120.5,
    indoor_humidity_act: 120.5,
    indoor_dewpoint_act_F: 120.5,
    temp_avg_F: 120.5,
    humidity_act: 120.5,
    dewpoint_act_F: 120.5,
    heatindex_act_F: 120.5,
    pressure_act_hPa: 120.5,
    pressure_sealevel_act_inHg: 120.5,
    wind_chill_act_F: 120.5,
    wind_speed_act_mph: 120.5,
    wind_speed_average_mph: 120.5,
    wind_speed_avg10_mph: 120.5,
    wind_speed_max_mph: 120.5,
    wind_dir_act: 120.5,
    wind_dir_act_en: "some wind_dir_act_en",
    wind_dir_avg: 120.5,
    wind_dir_avg_en: "some wind_dir_avg_en",
    uv_index_avg: 120.5,
    uv_index_max: 120.5,
    solar_rad_avg_wm2: 120.5,
    solar_rad_max_wm2: 120.5,
    lightning_distance_avg_miles: 120.5,
    lightning_energy_avg: 120.5,
    lightning_energy_max: 120.5,
    lightning_strike_count: 42,
    rain_rate_act_in: 120.5,
    rain_total_day_in: 120.5
  }
  @update_attrs %{
    station: "some updated station",
    indoor_temp_avg_F: 456.7,
    indoor_humidity_act: 456.7,
    indoor_dewpoint_act_F: 456.7,
    temp_avg_F: 456.7,
    humidity_act: 456.7,
    dewpoint_act_F: 456.7,
    heatindex_act_F: 456.7,
    pressure_act_hPa: 456.7,
    pressure_sealevel_act_inHg: 456.7,
    wind_chill_act_F: 456.7,
    wind_speed_act_mph: 456.7,
    wind_speed_average_mph: 456.7,
    wind_speed_avg10_mph: 456.7,
    wind_speed_max_mph: 456.7,
    wind_dir_act: 456.7,
    wind_dir_act_en: "some updated wind_dir_act_en",
    wind_dir_avg: 456.7,
    wind_dir_avg_en: "some updated wind_dir_avg_en",
    uv_index_avg: 456.7,
    uv_index_max: 456.7,
    solar_rad_avg_wm2: 456.7,
    solar_rad_max_wm2: 456.7,
    lightning_distance_avg_miles: 456.7,
    lightning_energy_avg: 456.7,
    lightning_energy_max: 456.7,
    lightning_strike_count: 43,
    rain_rate_act_in: 456.7,
    rain_total_day_in: 456.7
  }
  @invalid_attrs %{station: nil, indoor_temp_avg_F: nil, indoor_humidity_act: nil, indoor_dewpoint_act_F: nil, temp_avg_F: nil, humidity_act: nil, dewpoint_act_F: nil, heatindex_act_F: nil, pressure_act_hPa: nil, pressure_sealevel_act_inHg: nil, wind_chill_act_F: nil, wind_speed_act_mph: nil, wind_speed_average_mph: nil, wind_speed_avg10_mph: nil, wind_speed_max_mph: nil, wind_dir_act: nil, wind_dir_act_en: nil, wind_dir_avg: nil, wind_dir_avg_en: nil, uv_index_avg: nil, uv_index_max: nil, solar_rad_avg_wm2: nil, solar_rad_max_wm2: nil, lightning_distance_avg_miles: nil, lightning_energy_avg: nil, lightning_energy_max: nil, lightning_strike_count: nil, rain_rate_act_in: nil, rain_total_day_in: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all meteobridge_ten_minute_observations", %{conn: conn} do
      conn = get(conn, ~p"/api/meteobridge_ten_minute_observations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ten_minute_observation" do
    test "renders ten_minute_observation when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_ten_minute_observations", ten_minute_observation: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/meteobridge_ten_minute_observations/#{id}")

      assert %{
               "id" => ^id,
               "dewpoint_act_F" => 120.5,
               "heatindex_act_F" => 120.5,
               "humidity_act" => 120.5,
               "indoor_dewpoint_act_F" => 120.5,
               "indoor_humidity_act" => 120.5,
               "indoor_temp_avg_F" => 120.5,
               "lightning_distance_avg_miles" => 120.5,
               "lightning_energy_avg" => 120.5,
               "lightning_energy_max" => 120.5,
               "lightning_strike_count" => 42,
               "pressure_act_hPa" => 120.5,
               "pressure_sealevel_act_inHg" => 120.5,
               "rain_rate_act_in" => 120.5,
               "rain_total_day_in" => 120.5,
               "solar_rad_avg_wm2" => 120.5,
               "solar_rad_max_wm2" => 120.5,
               "station" => "some station",
               "temp_avg_F" => 120.5,
               "uv_index_avg" => 120.5,
               "uv_index_max" => 120.5,
               "wind_chill_act_F" => 120.5,
               "wind_dir_act" => 120.5,
               "wind_dir_act_en" => "some wind_dir_act_en",
               "wind_dir_avg" => 120.5,
               "wind_dir_avg_en" => "some wind_dir_avg_en",
               "wind_speed_act_mph" => 120.5,
               "wind_speed_average_mph" => 120.5,
               "wind_speed_avg10_mph" => 120.5,
               "wind_speed_max_mph" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/meteobridge_ten_minute_observations", ten_minute_observation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_ten_minute_observation(_) do
    ten_minute_observation = ten_minute_observation_fixture()
    %{ten_minute_observation: ten_minute_observation}
  end
end
