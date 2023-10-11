defmodule WeatherMoss.Repo.Migrations.CreateTempestEventStrike do
  use Ecto.Migration

  def change do
    create table(:tempest_event_strike) do
      add :hub_sn, :string
      add :serial_number, :string
      add :timestamp, :utc_datetime
    end

    create index(:tempest_event_strike, [:hub_sn, :timestamp])
  end
end
