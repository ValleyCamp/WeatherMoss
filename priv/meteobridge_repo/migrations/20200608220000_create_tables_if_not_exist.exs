defmodule WeatherMoss.MeteobridgeRepo.Migrations.CreateTablesIfNotExist do
  use Ecto.Migration

  # NOTE: This is reverse engineered from the existing production database with 5+ years of live data in it.
  #       Any strangeness in why they are the way they are is likely due to that.
  #       Any future changes to correct/change things must take into account the Meteobridge hardware device
  #       happily inserting data into the production database.
  def change do
    create_if_not_exists table("housestation_10min_all") do
      add :dateTime, :utc_datetime
      add :tempOutCur, :decimal, precision: 4, scale: 1
      add :humOutCur, :integer
      add :pressCur, :decimal, precision: 4, scale: 2
      add :dewCur, :decimal, precision: 4, scale: 1
      add :heatIdxCur, :decimal, precision: 4, scale: 1
      add :windChillCur, :decimal, precision: 4, scale: 1
      add :tempInCur, :decimal, precision: 4, scale: 1
      add :humInCur, :integer
      add :windSpeedCur, :decimal, precision: 4, scale: 1
      add :windAvgSpeedCur, :decimal, precision: 4, scale: 1
      add :windDirCur, :integer
      add :windDirCurEng, :string, size: 3
      add :windGust10, :decimal, precision: 4, scale: 1
      add :windDirAvg10, :integer
      add :windDirAvg10Eng, :string, size: 3
      add :uVAvg10, :decimal, precision: 6, scale: 2
      add :uVMax10, :decimal, precision: 6, scale: 2
      add :solarRadAvg10, :decimal, precision: 6, scale: 2
      add :solarRadMax10, :decimal, precision: 6, scale: 2
      add :rainRateCur, :decimal, precision: 5, scale: 2
      add :rainDay, :decimal, precision: 4, scale: 2
      add :rainYest, :decimal, precision: 4, scale: 2
      add :rainMonth, :decimal, precision: 5, scale: 2
      add :rainYear, :decimal, precision: 5, scale: 2
    end

    create_if_not_exists table("housestation_15sec_raintemp") do
      add :dateTime, :utc_datetime
      add :tempOutCur, :decimal, precision: 4, scale: 1
      add :rainRateCur, :decimal, precision: 5, scale: 2
      add :rainDay, :decimal, precision: 4, scale: 2
    end

    create_if_not_exists table("housestation_15sec_wind") do
      add :dateTime, :utc_datetime
      add :windDirCur, :integer
      add :windDirCurEng, :string, size: 3
      add :windSpeedCur, :decimal, precision: 4, scale: 1
    end
  end
end
