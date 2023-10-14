defmodule WeatherMoss.Meteobridge.FifteenSecondObservation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meteobridge_fifteen_second_observations" do
    field :station, :string
    field :temp_act_F, :float
    field :rain_rate_act_in, :float
    field :rain_total_day_in, :float
    field :wind_dir_act, :integer
    field :wind_dir_act_en, :string
    field :wind_speed_act_mph, :float
    field :solar_rad_act_wm2, :float
    field :uv_index, :float

    timestamps()
  end

  @doc false
  def changeset(fifteen_second_observation, attrs) do
    fifteen_second_observation
    |> cast(attrs, [:station, :temp_act_F, :rain_rate_act_in, :rain_total_day_in, :wind_dir_act, :wind_dir_act_en, :wind_speed_act_mph, :solar_rad_act_wm2, :uv_index])
    |> validate_required([:station, :temp_act_F, :rain_rate_act_in, :rain_total_day_in, :wind_dir_act, :wind_dir_act_en, :wind_speed_act_mph, :solar_rad_act_wm2, :uv_index])
  end
end
