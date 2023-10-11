defmodule WeatherMoss.Repo.Migrations.CreateTempestEventPrecipitation do
  use Ecto.Migration

  def change do
    create table(:tempest_event_precipitation) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
    end

    create index(:tempest_event_precipitation, [:hub_sn, :timestamp])
  end
end
