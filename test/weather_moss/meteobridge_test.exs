defmodule WeatherMoss.MeteobridgeTest do
  use WeatherMoss.DataCase

  alias WeatherMoss.Meteobridge

  describe "meteobridge_ten_minute_observations" do
    alias WeatherMoss.Meteobridge.TenMinuteObservation

    import WeatherMoss.MeteobridgeFixtures

    @invalid_attrs %{station: nil, indoor_temp_avg_F: nil, indoor_humidity_act: nil, indoor_dewpoint_act_F: nil, temp_avg_F: nil, humidity_act: nil, dewpoint_act_F: nil, heatindex_act_F: nil, pressure_act_hPa: nil, pressure_sealevel_act_inHg: nil, wind_chill_act_F: nil, wind_speed_act_mph: nil, wind_speed_average_mph: nil, wind_speed_avg10_mph: nil, wind_speed_max_mph: nil, wind_dir_act: nil, wind_dir_act_en: nil, wind_dir_avg: nil, wind_dir_avg_en: nil, uv_index_avg: nil, uv_index_max: nil, solar_rad_avg_wm2: nil, solar_rad_max_wm2: nil, lightning_distance_avg_miles: nil, lightning_energy_avg: nil, lightning_energy_max: nil, lightning_strike_count: nil, rain_rate_act_in: nil, rain_total_day_in: nil}

    test "list_meteobridge_ten_minute_observations/0 returns all meteobridge_ten_minute_observations" do
      ten_minute_observation = ten_minute_observation_fixture()
      assert Meteobridge.list_meteobridge_ten_minute_observations() == [ten_minute_observation]
    end

    test "get_ten_minute_observation!/1 returns the ten_minute_observation with given id" do
      ten_minute_observation = ten_minute_observation_fixture()
      assert Meteobridge.get_ten_minute_observation!(ten_minute_observation.id) == ten_minute_observation
    end

    test "create_ten_minute_observation/1 with valid data creates a ten_minute_observation" do
      valid_attrs = %{station: "some station", indoor_temp_avg_F: 120.5, indoor_humidity_act: 120.5, indoor_dewpoint_act_F: 120.5, temp_avg_F: 120.5, humidity_act: 120.5, dewpoint_act_F: 120.5, heatindex_act_F: 120.5, pressure_act_hPa: 120.5, pressure_sealevel_act_inHg: 120.5, wind_chill_act_F: 120.5, wind_speed_act_mph: 120.5, wind_speed_average_mph: 120.5, wind_speed_avg10_mph: 120.5, wind_speed_max_mph: 120.5, wind_dir_act: 120.5, wind_dir_act_en: "some wind_dir_act_en", wind_dir_avg: 120.5, wind_dir_avg_en: "some wind_dir_avg_en", uv_index_avg: 120.5, uv_index_max: 120.5, solar_rad_avg_wm2: 120.5, solar_rad_max_wm2: 120.5, lightning_distance_avg_miles: 120.5, lightning_energy_avg: 120.5, lightning_energy_max: 120.5, lightning_strike_count: 42, rain_rate_act_in: 120.5, rain_total_day_in: 120.5}

      assert {:ok, %TenMinuteObservation{} = ten_minute_observation} = Meteobridge.create_ten_minute_observation(valid_attrs)
      assert ten_minute_observation.station == "some station"
      assert ten_minute_observation.indoor_temp_avg_F == 120.5
      assert ten_minute_observation.indoor_humidity_act == 120.5
      assert ten_minute_observation.indoor_dewpoint_act_F == 120.5
      assert ten_minute_observation.temp_avg_F == 120.5
      assert ten_minute_observation.humidity_act == 120.5
      assert ten_minute_observation.dewpoint_act_F == 120.5
      assert ten_minute_observation.heatindex_act_F == 120.5
      assert ten_minute_observation.pressure_act_hPa == 120.5
      assert ten_minute_observation.pressure_sealevel_act_inHg == 120.5
      assert ten_minute_observation.wind_chill_act_F == 120.5
      assert ten_minute_observation.wind_speed_act_mph == 120.5
      assert ten_minute_observation.wind_speed_average_mph == 120.5
      assert ten_minute_observation.wind_speed_avg10_mph == 120.5
      assert ten_minute_observation.wind_speed_max_mph == 120.5
      assert ten_minute_observation.wind_dir_act == 120.5
      assert ten_minute_observation.wind_dir_act_en == "some wind_dir_act_en"
      assert ten_minute_observation.wind_dir_avg == 120.5
      assert ten_minute_observation.wind_dir_avg_en == "some wind_dir_avg_en"
      assert ten_minute_observation.uv_index_avg == 120.5
      assert ten_minute_observation.uv_index_max == 120.5
      assert ten_minute_observation.solar_rad_avg_wm2 == 120.5
      assert ten_minute_observation.solar_rad_max_wm2 == 120.5
      assert ten_minute_observation.lightning_distance_avg_miles == 120.5
      assert ten_minute_observation.lightning_energy_avg == 120.5
      assert ten_minute_observation.lightning_energy_max == 120.5
      assert ten_minute_observation.lightning_strike_count == 42
      assert ten_minute_observation.rain_rate_act_in == 120.5
      assert ten_minute_observation.rain_total_day_in == 120.5
    end

    test "create_ten_minute_observation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meteobridge.create_ten_minute_observation(@invalid_attrs)
    end

    test "update_ten_minute_observation/2 with valid data updates the ten_minute_observation" do
      ten_minute_observation = ten_minute_observation_fixture()
      update_attrs = %{station: "some updated station", indoor_temp_avg_F: 456.7, indoor_humidity_act: 456.7, indoor_dewpoint_act_F: 456.7, temp_avg_F: 456.7, humidity_act: 456.7, dewpoint_act_F: 456.7, heatindex_act_F: 456.7, pressure_act_hPa: 456.7, pressure_sealevel_act_inHg: 456.7, wind_chill_act_F: 456.7, wind_speed_act_mph: 456.7, wind_speed_average_mph: 456.7, wind_speed_avg10_mph: 456.7, wind_speed_max_mph: 456.7, wind_dir_act: 456.7, wind_dir_act_en: "some updated wind_dir_act_en", wind_dir_avg: 456.7, wind_dir_avg_en: "some updated wind_dir_avg_en", uv_index_avg: 456.7, uv_index_max: 456.7, solar_rad_avg_wm2: 456.7, solar_rad_max_wm2: 456.7, lightning_distance_avg_miles: 456.7, lightning_energy_avg: 456.7, lightning_energy_max: 456.7, lightning_strike_count: 43, rain_rate_act_in: 456.7, rain_total_day_in: 456.7}

      assert {:ok, %TenMinuteObservation{} = ten_minute_observation} = Meteobridge.update_ten_minute_observation(ten_minute_observation, update_attrs)
      assert ten_minute_observation.station == "some updated station"
      assert ten_minute_observation.indoor_temp_avg_F == 456.7
      assert ten_minute_observation.indoor_humidity_act == 456.7
      assert ten_minute_observation.indoor_dewpoint_act_F == 456.7
      assert ten_minute_observation.temp_avg_F == 456.7
      assert ten_minute_observation.humidity_act == 456.7
      assert ten_minute_observation.dewpoint_act_F == 456.7
      assert ten_minute_observation.heatindex_act_F == 456.7
      assert ten_minute_observation.pressure_act_hPa == 456.7
      assert ten_minute_observation.pressure_sealevel_act_inHg == 456.7
      assert ten_minute_observation.wind_chill_act_F == 456.7
      assert ten_minute_observation.wind_speed_act_mph == 456.7
      assert ten_minute_observation.wind_speed_average_mph == 456.7
      assert ten_minute_observation.wind_speed_avg10_mph == 456.7
      assert ten_minute_observation.wind_speed_max_mph == 456.7
      assert ten_minute_observation.wind_dir_act == 456.7
      assert ten_minute_observation.wind_dir_act_en == "some updated wind_dir_act_en"
      assert ten_minute_observation.wind_dir_avg == 456.7
      assert ten_minute_observation.wind_dir_avg_en == "some updated wind_dir_avg_en"
      assert ten_minute_observation.uv_index_avg == 456.7
      assert ten_minute_observation.uv_index_max == 456.7
      assert ten_minute_observation.solar_rad_avg_wm2 == 456.7
      assert ten_minute_observation.solar_rad_max_wm2 == 456.7
      assert ten_minute_observation.lightning_distance_avg_miles == 456.7
      assert ten_minute_observation.lightning_energy_avg == 456.7
      assert ten_minute_observation.lightning_energy_max == 456.7
      assert ten_minute_observation.lightning_strike_count == 43
      assert ten_minute_observation.rain_rate_act_in == 456.7
      assert ten_minute_observation.rain_total_day_in == 456.7
    end

    test "update_ten_minute_observation/2 with invalid data returns error changeset" do
      ten_minute_observation = ten_minute_observation_fixture()
      assert {:error, %Ecto.Changeset{}} = Meteobridge.update_ten_minute_observation(ten_minute_observation, @invalid_attrs)
      assert ten_minute_observation == Meteobridge.get_ten_minute_observation!(ten_minute_observation.id)
    end

    test "delete_ten_minute_observation/1 deletes the ten_minute_observation" do
      ten_minute_observation = ten_minute_observation_fixture()
      assert {:ok, %TenMinuteObservation{}} = Meteobridge.delete_ten_minute_observation(ten_minute_observation)
      assert_raise Ecto.NoResultsError, fn -> Meteobridge.get_ten_minute_observation!(ten_minute_observation.id) end
    end

    test "change_ten_minute_observation/1 returns a ten_minute_observation changeset" do
      ten_minute_observation = ten_minute_observation_fixture()
      assert %Ecto.Changeset{} = Meteobridge.change_ten_minute_observation(ten_minute_observation)
    end
  end

  describe "meteobridge_fifteen_second_observations" do
    alias WeatherMoss.Meteobridge.FifteenSecondObservation

    import WeatherMoss.MeteobridgeFixtures

    @invalid_attrs %{station: nil, temp_act_F: nil, rain_rate_act_in: nil, rain_total_day_in: nil, wind_dir_act: nil, wind_dir_act_en: nil, wind_speed_act_mph: nil, solar_rad_act_wm2: nil, uv_index: nil}

    test "list_meteobridge_fifteen_second_observations/0 returns all meteobridge_fifteen_second_observations" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      assert Meteobridge.list_meteobridge_fifteen_second_observations() == [fifteen_second_observation]
    end

    test "get_fifteen_second_observation!/1 returns the fifteen_second_observation with given id" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      assert Meteobridge.get_fifteen_second_observation!(fifteen_second_observation.id) == fifteen_second_observation
    end

    test "create_fifteen_second_observation/1 with valid data creates a fifteen_second_observation" do
      valid_attrs = %{station: "some station", temp_act_F: 120.5, rain_rate_act_in: 120.5, rain_total_day_in: 120.5, wind_dir_act: 42, wind_dir_act_en: "some wind_dir_act_en", wind_speed_act_mph: 120.5, solar_rad_act_wm2: 120.5, uv_index: 120.5}

      assert {:ok, %FifteenSecondObservation{} = fifteen_second_observation} = Meteobridge.create_fifteen_second_observation(valid_attrs)
      assert fifteen_second_observation.station == "some station"
      assert fifteen_second_observation.temp_act_F == 120.5
      assert fifteen_second_observation.rain_rate_act_in == 120.5
      assert fifteen_second_observation.rain_total_day_in == 120.5
      assert fifteen_second_observation.wind_dir_act == 42
      assert fifteen_second_observation.wind_dir_act_en == "some wind_dir_act_en"
      assert fifteen_second_observation.wind_speed_act_mph == 120.5
      assert fifteen_second_observation.solar_rad_act_wm2 == 120.5
      assert fifteen_second_observation.uv_index == 120.5
    end

    test "create_fifteen_second_observation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meteobridge.create_fifteen_second_observation(@invalid_attrs)
    end

    test "update_fifteen_second_observation/2 with valid data updates the fifteen_second_observation" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      update_attrs = %{station: "some updated station", temp_act_F: 456.7, rain_rate_act_in: 456.7, rain_total_day_in: 456.7, wind_dir_act: 43, wind_dir_act_en: "some updated wind_dir_act_en", wind_speed_act_mph: 456.7, solar_rad_act_wm2: 456.7, uv_index: 456.7}

      assert {:ok, %FifteenSecondObservation{} = fifteen_second_observation} = Meteobridge.update_fifteen_second_observation(fifteen_second_observation, update_attrs)
      assert fifteen_second_observation.station == "some updated station"
      assert fifteen_second_observation.temp_act_F == 456.7
      assert fifteen_second_observation.rain_rate_act_in == 456.7
      assert fifteen_second_observation.rain_total_day_in == 456.7
      assert fifteen_second_observation.wind_dir_act == 43
      assert fifteen_second_observation.wind_dir_act_en == "some updated wind_dir_act_en"
      assert fifteen_second_observation.wind_speed_act_mph == 456.7
      assert fifteen_second_observation.solar_rad_act_wm2 == 456.7
      assert fifteen_second_observation.uv_index == 456.7
    end

    test "update_fifteen_second_observation/2 with invalid data returns error changeset" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      assert {:error, %Ecto.Changeset{}} = Meteobridge.update_fifteen_second_observation(fifteen_second_observation, @invalid_attrs)
      assert fifteen_second_observation == Meteobridge.get_fifteen_second_observation!(fifteen_second_observation.id)
    end

    test "delete_fifteen_second_observation/1 deletes the fifteen_second_observation" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      assert {:ok, %FifteenSecondObservation{}} = Meteobridge.delete_fifteen_second_observation(fifteen_second_observation)
      assert_raise Ecto.NoResultsError, fn -> Meteobridge.get_fifteen_second_observation!(fifteen_second_observation.id) end
    end

    test "change_fifteen_second_observation/1 returns a fifteen_second_observation changeset" do
      fifteen_second_observation = fifteen_second_observation_fixture()
      assert %Ecto.Changeset{} = Meteobridge.change_fifteen_second_observation(fifteen_second_observation)
    end
  end

  describe "meteobridge_start_of_day_observations" do
    alias WeatherMoss.Meteobridge.StartOfDayObservation

    import WeatherMoss.MeteobridgeFixtures

    @invalid_attrs %{station: nil, rain_total_yesterday_in: nil, rain_total_month_in: nil, rain_total_year_in: nil, solar_max_possible: nil, astronomical_sunrise: nil, astronomical_sunset: nil}

    test "list_meteobridge_start_of_day_observations/0 returns all meteobridge_start_of_day_observations" do
      start_of_day_observation = start_of_day_observation_fixture()
      assert Meteobridge.list_meteobridge_start_of_day_observations() == [start_of_day_observation]
    end

    test "get_start_of_day_observation!/1 returns the start_of_day_observation with given id" do
      start_of_day_observation = start_of_day_observation_fixture()
      assert Meteobridge.get_start_of_day_observation!(start_of_day_observation.id) == start_of_day_observation
    end

    test "create_start_of_day_observation/1 with valid data creates a start_of_day_observation" do
      valid_attrs = %{station: "some station", rain_total_yesterday_in: 120.5, rain_total_month_in: 120.5, rain_total_year_in: 120.5, solar_max_possible: 120.5, astronomical_sunrise: ~N[2023-10-13 13:53:00], astronomical_sunset: ~N[2023-10-13 13:53:00]}

      assert {:ok, %StartOfDayObservation{} = start_of_day_observation} = Meteobridge.create_start_of_day_observation(valid_attrs)
      assert start_of_day_observation.station == "some station"
      assert start_of_day_observation.rain_total_yesterday_in == 120.5
      assert start_of_day_observation.rain_total_month_in == 120.5
      assert start_of_day_observation.rain_total_year_in == 120.5
      assert start_of_day_observation.solar_max_possible == 120.5
      assert start_of_day_observation.astronomical_sunrise == ~N[2023-10-13 13:53:00]
      assert start_of_day_observation.astronomical_sunset == ~N[2023-10-13 13:53:00]
    end

    test "create_start_of_day_observation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meteobridge.create_start_of_day_observation(@invalid_attrs)
    end

    test "update_start_of_day_observation/2 with valid data updates the start_of_day_observation" do
      start_of_day_observation = start_of_day_observation_fixture()
      update_attrs = %{station: "some updated station", rain_total_yesterday_in: 456.7, rain_total_month_in: 456.7, rain_total_year_in: 456.7, solar_max_possible: 456.7, astronomical_sunrise: ~N[2023-10-14 13:53:00], astronomical_sunset: ~N[2023-10-14 13:53:00]}

      assert {:ok, %StartOfDayObservation{} = start_of_day_observation} = Meteobridge.update_start_of_day_observation(start_of_day_observation, update_attrs)
      assert start_of_day_observation.station == "some updated station"
      assert start_of_day_observation.rain_total_yesterday_in == 456.7
      assert start_of_day_observation.rain_total_month_in == 456.7
      assert start_of_day_observation.rain_total_year_in == 456.7
      assert start_of_day_observation.solar_max_possible == 456.7
      assert start_of_day_observation.astronomical_sunrise == ~N[2023-10-14 13:53:00]
      assert start_of_day_observation.astronomical_sunset == ~N[2023-10-14 13:53:00]
    end

    test "update_start_of_day_observation/2 with invalid data returns error changeset" do
      start_of_day_observation = start_of_day_observation_fixture()
      assert {:error, %Ecto.Changeset{}} = Meteobridge.update_start_of_day_observation(start_of_day_observation, @invalid_attrs)
      assert start_of_day_observation == Meteobridge.get_start_of_day_observation!(start_of_day_observation.id)
    end

    test "delete_start_of_day_observation/1 deletes the start_of_day_observation" do
      start_of_day_observation = start_of_day_observation_fixture()
      assert {:ok, %StartOfDayObservation{}} = Meteobridge.delete_start_of_day_observation(start_of_day_observation)
      assert_raise Ecto.NoResultsError, fn -> Meteobridge.get_start_of_day_observation!(start_of_day_observation.id) end
    end

    test "change_start_of_day_observation/1 returns a start_of_day_observation changeset" do
      start_of_day_observation = start_of_day_observation_fixture()
      assert %Ecto.Changeset{} = Meteobridge.change_start_of_day_observation(start_of_day_observation)
    end
  end

  describe "meteobridge_end_of_day_observations" do
    alias WeatherMoss.Meteobridge.EndOfDayObservation

    import WeatherMoss.MeteobridgeFixtures

    @invalid_attrs %{station: nil, max_temp_F: nil, min_temp_F: nil, max_rain_rate_in: nil, min_rain_rate_in: nil, max_wind_gust_mph: nil, max_solar_rad_wm2: nil}

    test "list_meteobridge_end_of_day_observations/0 returns all meteobridge_end_of_day_observations" do
      end_of_day_observation = end_of_day_observation_fixture()
      assert Meteobridge.list_meteobridge_end_of_day_observations() == [end_of_day_observation]
    end

    test "get_end_of_day_observation!/1 returns the end_of_day_observation with given id" do
      end_of_day_observation = end_of_day_observation_fixture()
      assert Meteobridge.get_end_of_day_observation!(end_of_day_observation.id) == end_of_day_observation
    end

    test "create_end_of_day_observation/1 with valid data creates a end_of_day_observation" do
      valid_attrs = %{station: "some station", max_temp_F: 120.5, min_temp_F: 120.5, max_rain_rate_in: 120.5, min_rain_rate_in: 120.5, max_wind_gust_mph: 120.5, max_solar_rad_wm2: 120.5}

      assert {:ok, %EndOfDayObservation{} = end_of_day_observation} = Meteobridge.create_end_of_day_observation(valid_attrs)
      assert end_of_day_observation.station == "some station"
      assert end_of_day_observation.max_temp_F == 120.5
      assert end_of_day_observation.min_temp_F == 120.5
      assert end_of_day_observation.max_rain_rate_in == 120.5
      assert end_of_day_observation.min_rain_rate_in == 120.5
      assert end_of_day_observation.max_wind_gust_mph == 120.5
      assert end_of_day_observation.max_solar_rad_wm2 == 120.5
    end

    test "create_end_of_day_observation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meteobridge.create_end_of_day_observation(@invalid_attrs)
    end

    test "update_end_of_day_observation/2 with valid data updates the end_of_day_observation" do
      end_of_day_observation = end_of_day_observation_fixture()
      update_attrs = %{station: "some updated station", max_temp_F: 456.7, min_temp_F: 456.7, max_rain_rate_in: 456.7, min_rain_rate_in: 456.7, max_wind_gust_mph: 456.7, max_solar_rad_wm2: 456.7}

      assert {:ok, %EndOfDayObservation{} = end_of_day_observation} = Meteobridge.update_end_of_day_observation(end_of_day_observation, update_attrs)
      assert end_of_day_observation.station == "some updated station"
      assert end_of_day_observation.max_temp_F == 456.7
      assert end_of_day_observation.min_temp_F == 456.7
      assert end_of_day_observation.max_rain_rate_in == 456.7
      assert end_of_day_observation.min_rain_rate_in == 456.7
      assert end_of_day_observation.max_wind_gust_mph == 456.7
      assert end_of_day_observation.max_solar_rad_wm2 == 456.7
    end

    test "update_end_of_day_observation/2 with invalid data returns error changeset" do
      end_of_day_observation = end_of_day_observation_fixture()
      assert {:error, %Ecto.Changeset{}} = Meteobridge.update_end_of_day_observation(end_of_day_observation, @invalid_attrs)
      assert end_of_day_observation == Meteobridge.get_end_of_day_observation!(end_of_day_observation.id)
    end

    test "delete_end_of_day_observation/1 deletes the end_of_day_observation" do
      end_of_day_observation = end_of_day_observation_fixture()
      assert {:ok, %EndOfDayObservation{}} = Meteobridge.delete_end_of_day_observation(end_of_day_observation)
      assert_raise Ecto.NoResultsError, fn -> Meteobridge.get_end_of_day_observation!(end_of_day_observation.id) end
    end

    test "change_end_of_day_observation/1 returns a end_of_day_observation changeset" do
      end_of_day_observation = end_of_day_observation_fixture()
      assert %Ecto.Changeset{} = Meteobridge.change_end_of_day_observation(end_of_day_observation)
    end
  end
end
