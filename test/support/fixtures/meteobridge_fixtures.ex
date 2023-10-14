defmodule WeatherMoss.MeteobridgeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WeatherMoss.Meteobridge` context.
  """

  @doc """
  Generate a ten_minute_observation.
  """
  def ten_minute_observation_fixture(attrs \\ %{}) do
    {:ok, ten_minute_observation} =
      attrs
      |> Enum.into(%{
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
      })
      |> WeatherMoss.Meteobridge.create_ten_minute_observation()

    ten_minute_observation
  end

  @doc """
  Generate a fifteen_second_observation.
  """
  def fifteen_second_observation_fixture(attrs \\ %{}) do
    {:ok, fifteen_second_observation} =
      attrs
      |> Enum.into(%{
        station: "some station",
        temp_act_F: 120.5,
        rain_rate_act_in: 120.5,
        rain_total_day_in: 120.5,
        wind_dir_act: 42,
        wind_dir_act_en: "some wind_dir_act_en",
        wind_speed_act_mph: 120.5,
        solar_rad_act_wm2: 120.5,
        uv_index: 120.5
      })
      |> WeatherMoss.Meteobridge.create_fifteen_second_observation()

    fifteen_second_observation
  end

  @doc """
  Generate a start_of_day_observation.
  """
  def start_of_day_observation_fixture(attrs \\ %{}) do
    {:ok, start_of_day_observation} =
      attrs
      |> Enum.into(%{
        station: "some station",
        rain_total_yesterday_in: 120.5,
        rain_total_month_in: 120.5,
        rain_total_year_in: 120.5,
        solar_max_possible: 120.5,
        astronomical_sunrise: ~N[2023-10-13 13:53:00],
        astronomical_sunset: ~N[2023-10-13 13:53:00]
      })
      |> WeatherMoss.Meteobridge.create_start_of_day_observation()

    start_of_day_observation
  end

  @doc """
  Generate a end_of_day_observation.
  """
  def end_of_day_observation_fixture(attrs \\ %{}) do
    {:ok, end_of_day_observation} =
      attrs
      |> Enum.into(%{
        station: "some station",
        max_temp_F: 120.5,
        min_temp_F: 120.5,
        max_rain_rate_in: 120.5,
        min_rain_rate_in: 120.5,
        max_wind_gust_mph: 120.5,
        max_solar_rad_wm2: 120.5
      })
      |> WeatherMoss.Meteobridge.create_end_of_day_observation()

    end_of_day_observation
  end
end
