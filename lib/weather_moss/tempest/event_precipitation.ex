defmodule WeatherMoss.Tempest.EventPrecipitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_event_precipitation" do
    field :timestamp, :utc_datetime
    field :hub_sn, :string
    field :serial_number, :string
  end

  @doc false
  def changeset(event_precipitation, attrs) do
    event_precipitation
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp])
    |> validate_required([:hub_sn, :serial_number, :timestamp])
  end
end
