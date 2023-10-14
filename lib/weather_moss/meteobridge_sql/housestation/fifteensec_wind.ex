defmodule WeatherMoss.MeteobridgeSQL.Housestation.FifteensecondWind do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias __MODULE__

  @primary_key {:id, :id, autogenerate: true}

  # The SQL Query we use to insert this data from the Meteobridge services interface:
  # INSERT INTO `housestation_15sec_wind` (`DateTime`, `WindDirCur`, `WindDirCurEng`, `WindSpeedCur`) VALUES ('[YYYY]-[MM]-[DD] [hh]:[mm]:[ss]', '[wind0dir-act]', '[wind0dir-act=endir]', '[wind0wind-act=mph]')
  schema "housestation_15sec_wind" do
    field :dateTime, :utc_datetime
    field :windDirCur, :integer
    field :windDirCurEng, :string
    field :windSpeedCur, :decimal
  end

  def changeset(%FifteensecondWind{} = struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:dateTime, :windDirCur, :windDirCurEng, :windSpeedCur])
    |> validate_required([:dateTime, :windDirCur, :windDirCurEng, :windSpeedCur])
  end

  def in_last_day(query) do
    dayago = DateTime.utc_now
            |> DateTime.add(-86400, :second) # 60*60*24

    from r in query,
      where: r.dateTime >= ^dayago
  end

  def in_last_month(query) do
    monthago = DateTime.utc_now
            |> DateTime.add(-26784000, :second) # 60*60*24*31

    from r in query,
      where: r.dateTime >= ^monthago
  end

  def max_wind_speed(query) do
    from r in query,
      select: max(r.windSpeedCur)
  end

end