defmodule WeatherFlow.PurpleAir.DataLogger do
  @moduledoc """

  http://purpleair-b319.actual.valleycamp.org/json?live=true
  If you don't use live=true it's a 2-minute average allegedly

  ## Examples of fields in the JSON that we'll ignore
  "Geo": "PurpleAir-b319",
  "Mem": 11528,
  "memfrag": 39,
  "memfb": 6416,
  "memcs": 352,
  "Id": 15762,
  "lat": 47.466999,
  "lon": -121.680496,
  "Adc": 0.01,
  "loggingrate": 15,
  "place": "outside",
  "version": "7.04",
  "uptime": 1894535,
  "period": 120,
  "httpsuccess": 30639,
  "httpsends": 32098,
  "hardwareversion": "3.0",
  "hardwarediscovered": "3.0+OPENLOG+31954 MB+RV3028+BME68X+PMSX003-A+PMSX003-B",
  "pa_latency": 445,
  "response": 201,
  "response_date": 1697062328,
  "latency": 484,
  "wlstate": "Connected",
  "status_0": 2,
  "status_1": 0,
  "status_2": 2,
  "status_3": 2,
  "status_4": 2,
  "status_6": 2,
  "ssid": "Valley Camp - Staff"

  ## Examples of non-AQI fields that we'll be saving
  "SensorId": "8:3a:8d:cb:b3:19",
  "DateTime": "2023/10/11T22:13:06z",
  "rssi": -72,
  "current_temp_f": 69,
  "current_humidity": 49,
  "current_dewpoint_f": 49,
  "pressure": 979,
  "current_temp_f_680": 69,
  "current_humidity_680": 49,
  "current_dewpoint_f_680": 49,
  "pressure_680": 979,
  "gas_680": 103.26,

  ## AQI Data Fields
  All fields are assumed to be Float type, even though examples show integer.
  This should be analyzed and confirmed after collecting some data.
  The only fields NOT float are the aqic (AQI Color?) fields, which are rgb()
  strings, presumed to be used for LED status indicators?

  ### Fields in JSON, which aren't in the SD card:
  p25aqic : Looks like "rgb(0,228,0)". Presumed to be a LED color string used by the hardware to indicate status?
  p25aqic_b : Looks like "rgb(0,228,0)". Presumed to be a LED color string used by the hardware to indicate status?
  pm2.5_aqi : Assuming this may be one of the fields in the SD, but not sure if it's the CF1 or the ATM?
  pm2.5_aqi_b : Assuming this may be one of the fields in the SD, but not sure if it's the CF1 or the ATM?

  ### Fields in both:
  pm1_0_cf_1 : Channel A CF=1 PM1.0 particulate mass in ug/m3.
  pm2_5_cf_1 : Channel A CF=1 PM2.5 particulate mass in ug/m3.
  pm10_0_cf_1 : Channel A CF=1 PM10.0 particulate mass in ug/m3.
  pm1_0_atm : Channel A ATM PM1.0 particulate mass in ug/m3.
  pm2_5_atm : Channel A ATM PM2.5 particulate mass in ug/m3.
  pm10_0_atm : Channel A ATM PM10.0 particulate mass in ug/m3.
  p_0_3_um : Channel A 0.3-micrometer particle counts per deciliter of air.
  p_0_5_um : Channel A 0.5-micrometer particle counts per deciliter of air.
  p_1_0_um : Channel A 1.0-micrometer particle counts per deciliter of air.
  p_2_5_um : Channel A 2.5-micrometer particle counts per deciliter of air.
  p_5_0_um : Channel A 5.0-micrometer particle counts per deciliter of air.
  p_10_0_um : Channel A 10.0-micrometer particle counts per deciliter of air.
  pm1_0_cf_1_b : Channel B CF=1 PM1.0 particulate mass in ug/m3.
  pm2_5_cf_1_b : Channel B CF=1 PM2.5 particulate mass in ug/m3.
  pm10_0_cf_1_b : Channel B CF=1 PM10.0 particulate mass in ug/m3.
  pm1_0_atm_b : Channel B ATM PM1.0 particulate mass in ug/m3.
  pm2_5_atm_b : Channel B ATM PM2.5 particulate mass in ug/m3.
  pm10_0_atm_b : Channel B ATM PM10.0 particulate mass in ug/m3.
  p_0_3_um_b : Channel B 0.3 micrometer particle counts per deciliter of air.
  p_0_5_um_b : Channel B 0.5 micrometer particle counts per deciliter of air.
  p_1_0_um_b : Channel B 1.0 micrometer particle counts per deciliter of air.
  p_2_5_um_b : Channel B 2.5 micrometer particle counts per deciliter of air.
  p_5_0_um_b : Channel B 5.0 micrometer particle counts per deciliter of air.
  p_10_0_um_b : Channel B 10.0 micrometer particle counts per deciliter of air.

  ### Fields in SD, but not in JSON:
  pm2.5_aqi_cf_1 : Channel A CF=1 calculated US EPA PM2.5 AQI.
  pm2.5_aqi_atm : Channel A ATM calculated US EPA PM2.5 AQI.
  pm2.5_aqi_cf_1_b : Channel B CF=1 calculated US EPA PM2.5 AQI.
  pm2.5_aqi_atm_b : Channel B ATM calculated US EPA PM2.5 AQI.
  """

  alias WeatherMoss.Repo
  alias WeatherMoss.PurpleAir.Observation
  require Logger

  def fetch_and_save(device_address) do
    with {:ok, resp} <- HTTPoison.get("#{device_address}/json?live=true"),
         {:ok, body} <- Jason.decode(resp.body),
         parsed_body <- parse_and_alter_body(body),
                  cs <- Observation.changeset(%Observation{}, parsed_body),
      {:ok, _schema} <- Repo.insert(cs) do
        Logger.debug("Successfully saved data from PurpleAir device at #{inspect device_address}")
    else
      {:error, %HTTPoison.Error{reason: reason}} -> Logger.error("Error fetching data from PurpleAir device at #{inspect device_address}. Reason was #{inspect reason}")
      {:error, %Jason.DecodeError{data: reason}} -> Logger.error("Error parsing data from PurpleAir device at #{inspect device_address}. Reason was #{inspect reason}")
      err -> Logger.error("Error handling data from PurpleAir device at #{inspect device_address}. Error was #{inspect err}")
    end
  end

  # The PurpleAir API returns dates in a weird format that we have to parse
  # manually: "2023/10/12T20:58:12z"
  defp parse_and_alter_body(body) do
    parsed_datetime =
      body["DateTime"]
      |> Timex.parse!("{YYYY}/{0M}/{0D}T{h24}:{m}:{s}z")
      |> Timex.to_datetime("Etc/UTC")

    body
      |> Map.replace!("DateTime", parsed_datetime)
      |> Map.put(:pm2_5_aqi, body["pm2.5_aqi"])
      |> Map.put(:pm2_5_aqi_b, body["pm2.5_aqi_b"])
  end
end