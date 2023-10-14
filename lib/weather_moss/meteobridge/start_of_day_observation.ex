defmodule WeatherMoss.Meteobridge.StartOfDayObservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meteobridge_start_of_day_observations" do
    field :station, :string
    field :rain_total_yesterday_in, :float
    field :rain_total_month_in, :float
    field :rain_total_year_in, :float
    field :solar_max_possible, :float
    field :astronomical_sunrise, :naive_datetime
    field :astronomical_sunset, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(start_of_day_observation, attrs) do
    start_of_day_observation
    |> cast(attrs, [:station, :rain_total_yesterday_in, :rain_total_month_in, :rain_total_year_in, :solar_max_possible, :astronomical_sunrise, :astronomical_sunset])
    |> validate_required([:station, :rain_total_yesterday_in, :rain_total_month_in, :rain_total_year_in, :solar_max_possible, :astronomical_sunrise, :astronomical_sunset])
  end
end
