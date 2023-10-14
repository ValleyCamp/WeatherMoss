defmodule WeatherMoss.MeteobridgeSQL.Housestation.FifteensecondRainAndTemp do
  use Ecto.Schema
  use WeatherMoss.MeteobridgeSQL.Housestation.SharedQueries
  use WeatherMoss.MeteobridgeSQL.Housestation.SharedRainAndTempQueries
  import Ecto.Query
  import Ecto.Changeset
  alias __MODULE__

  @primary_key {:id, :id, autogenerate: true}

  # The SQL Query we use to insert this data from the Meteobridge services interface:
  # INSERT INTO `housestation_15sec_raintemp` (`DateTime`, `TempOutCur`, `RainRateCur`, `RainDay`) VALUES ('[YYYY]-[MM]-[DD] [hh]:[mm]:[ss]', '[th0temp-act=F]', '[rain0rate-act=in.2]', '[rain0total-daysum=in.2]')
  schema "housestation_15sec_raintemp" do
    field :dateTime, :utc_datetime
    field :tempOutCur, :decimal
    field :rainRateCur, :decimal
    field :rainDay, :decimal
  end

  def changeset(%FifteensecondRainAndTemp{} = struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:dateTime, :tempOutCur, :rainRateCur, :rainDay])
    |> validate_required([:dateTime, :tempOutCur, :rainRateCur, :rainDay])
  end

  #defp cast_timestamp(%Ecto.Chargeset{} = changeset, field) when is_atom(field) do
    #changeset.params
  #end

end