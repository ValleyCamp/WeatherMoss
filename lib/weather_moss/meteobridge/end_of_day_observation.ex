defmodule WeatherMoss.Meteobridge.EndOfDayObservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meteobridge_end_of_day_observations" do
    field :station, :string
    field :max_temp_F, :float
    field :min_temp_F, :float
    field :max_rain_rate_in, :float
    field :min_rain_rate_in, :float
    field :max_wind_gust_mph, :float
    field :max_solar_rad_wm2, :float

    timestamps()
  end

  @doc false
  def changeset(end_of_day_observation, attrs) do
    end_of_day_observation
    |> cast(attrs, [:station, :max_temp_F, :min_temp_F, :max_rain_rate_in, :min_rain_rate_in, :max_wind_gust_mph, :max_solar_rad_wm2])
    |> validate_required([:station, :max_temp_F, :min_temp_F, :max_rain_rate_in, :min_rain_rate_in, :max_wind_gust_mph, :max_solar_rad_wm2])
  end
end
