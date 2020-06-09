defmodule WeatherMoss.MeteobridgeRepo.Migrations.CreateTablesIfNotExist do
  use Ecto.Migration

  # NOTE!
  # These are created from the schema, which was in turn created based on the existing database, present and full of 5+ years of data when this project was started.
  # This does NOT exactly mirror the production database in several ways:
  # 1) Production database uses InitialCaseKeys. This database uses lowerStartingCamelCase.
  # 2) Production database defines decimal precision, and varchar lengths. Mysql decimal precision (4,1) for example, to store only the necessary level of precision.
  # 3) ID field is a regular int in the production db, and is a bigint when created with this migration.
  # 
  # Inline below are the descriptions of the production database at the time this migration was created. 
  def change do
    #root@localhost [meteobridge]> desc housestation_10min_all;
    #+-----------------+--------------+------+-----+---------+----------------+
    #| Field           | Type         | Null | Key | Default | Extra          |
    #+-----------------+--------------+------+-----+---------+----------------+
    #| ID              | int(11)      | NO   | PRI | NULL    | auto_increment |
    #| DateTime        | datetime     | NO   |     | NULL    |                |
    #| TempOutCur      | decimal(4,1) | NO   |     | NULL    |                |
    #| HumOutCur       | int(11)      | NO   |     | NULL    |                |
    #| PressCur        | decimal(4,2) | NO   |     | NULL    |                |
    #| DewCur          | decimal(4,1) | NO   |     | NULL    |                |
    #| HeatIdxCur      | decimal(4,1) | NO   |     | NULL    |                |
    #| WindChillCur    | decimal(4,1) | NO   |     | NULL    |                |
    #| TempInCur       | decimal(4,1) | NO   |     | NULL    |                |
    #| HumInCur        | int(11)      | NO   |     | NULL    |                |
    #| WindSpeedCur    | decimal(4,1) | NO   |     | NULL    |                |
    #| WindAvgSpeedCur | decimal(4,1) | NO   |     | NULL    |                |
    #| WindDirCur      | int(11)      | NO   |     | NULL    |                |
    #| WindDirCurEng   | varchar(3)   | NO   |     | NULL    |                |
    #| WindGust10      | decimal(4,1) | NO   |     | NULL    |                |
    #| WindDirAvg10    | int(11)      | NO   |     | NULL    |                |
    #| WindDirAvg10Eng | varchar(3)   | NO   |     | NULL    |                |
    #| UVAvg10         | decimal(6,2) | NO   |     | NULL    |                |
    #| UVMax10         | decimal(6,2) | NO   |     | NULL    |                |
    #| SolarRadAvg10   | decimal(6,2) | NO   |     | NULL    |                |
    #| SolarRadMax10   | decimal(6,2) | NO   |     | NULL    |                |
    #| RainRateCur     | decimal(5,2) | NO   |     | NULL    |                |
    #| RainDay         | decimal(4,2) | NO   |     | NULL    |                |
    #| RainYest        | decimal(4,2) | NO   |     | NULL    |                |
    #| RainMonth       | decimal(5,2) | NO   |     | NULL    |                |
    #| RainYear        | decimal(5,2) | NO   |     | NULL    |                |
    #+-----------------+--------------+------+-----+---------+----------------+
    #26 rows in set (0.00 sec)
    create_if_not_exists table("housestation_10min_all") do
      add :dateTime, :utc_datetime
      add :tempOutCur, :decimal
      add :humOutCur, :integer
      add :pressCur, :decimal
      add :dewCur, :decimal
      add :heatIdxCur, :decimal
      add :windChillCur, :decimal
      add :tempInCur, :decimal
      add :humInCur, :integer
      add :windSpeedCur, :decimal
      add :windAvgSpeedCur, :decimal
      add :windDirCur, :integer
      add :windDirCurEng, :string
      add :windGust10, :decimal
      add :windDirAvg10, :integer
      add :windDirAvg10Eng, :string
      add :uVAvg10, :decimal
      add :uVMax10, :decimal
      add :solarRadAvg10, :decimal
      add :solarRadMax10, :decimal
      add :rainRateCur, :decimal
      add :rainDay, :decimal
      add :rainYest, :decimal
      add :rainMonth, :decimal
      add :rainYear, :decimal
    end

    #root@localhost [meteobridge]> desc housestation_15sec_raintemp;
    #+-------------+--------------+------+-----+---------+----------------+
    #| Field       | Type         | Null | Key | Default | Extra          |
    #+-------------+--------------+------+-----+---------+----------------+
    #| ID          | int(11)      | NO   | PRI | NULL    | auto_increment |
    #| DateTime    | datetime     | NO   |     | NULL    |                |
    #| TempOutCur  | decimal(4,1) | NO   |     | NULL    |                |
    #| RainRateCur | decimal(5,2) | NO   |     | NULL    |                |
    #| RainDay     | decimal(4,2) | NO   |     | NULL    |                |
    #+-------------+--------------+------+-----+---------+----------------+
    #5 rows in set (0.00 sec)
    create_if_not_exists table("housestation_15sec_raintemp") do
      add :dateTime, :utc_datetime
      add :tempOutCur, :decimal
      add :rainRateCur, :decimal
      add :rainDay, :decimal
    end

    #root@localhost [meteobridge]> desc housestation_15sec_wind;
    #+---------------+--------------+------+-----+---------+----------------+
    #| Field         | Type         | Null | Key | Default | Extra          |
    #+---------------+--------------+------+-----+---------+----------------+
    #| ID            | int(11)      | NO   | PRI | NULL    | auto_increment |
    #| DateTime      | datetime     | NO   |     | NULL    |                |
    #| WindDirCur    | int(11)      | NO   |     | NULL    |                |
    #| WindDirCurEng | varchar(3)   | NO   |     | NULL    |                |
    #| WindSpeedCur  | decimal(4,1) | NO   |     | NULL    |                |
    #+---------------+--------------+------+-----+---------+----------------+
    #5 rows in set (0.00 sec)
    create_if_not_exists table("housestation_15sec_wind") do
      add :dateTime, :utc_datetime
      add :windDirCur, :integer
      add :windDirCurEng, :string
      add :windSpeedCur, :decimal
    end
  end
end
