defmodule WeatherMoss.Tempest.EventStrike do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tempest_event_strike" do
    field :timestamp, :utc_datetime
    field :hub_sn, :string
    field :serial_number, :string
  end

  @doc false
  def changeset(event_strike, attrs) do
    event_strike
    |> cast(attrs, [:hub_sn, :serial_number, :timestamp])
    |> validate_required([:hub_sn, :serial_number, :timestamp])
  end
end
