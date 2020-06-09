defmodule WeatherMoss.MeteobridgeRepo.Migrations.AddIndexesToDates do
  use Ecto.Migration

  def change do
    create index(:housestation_15sec_wind, [:dateTime])
    create index(:housestation_15sec_raintemp, [:dateTime])
    create index(:housestation_10min_all, [:dateTime])
  end
end
