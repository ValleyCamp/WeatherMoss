defmodule WeatherMoss.Meteobridge do
  @moduledoc """
  A module that provides access to the data in the Meteobridge database.
  This database is a MySQL database that the Meteobridge device inserts data into. We will treat
  this database as a read-only database.

  In order to prevent the database from being slammed with queries we'll cache the latest results
  and sweep them from the cache if the cached result age is higher than the interval that the
  Meteobridge device inserts data into the DB. (This means that if no clients are accessing the
  cache, we won't be running any SQL queries at all, huzzah.)
  """
  import Ecto.Query 
  use GenServer 

  @table :meteobridge_cache
  @sweep_after :timer.seconds(15)

  ## GenServer Client
  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Get the latest results from the cache. If no results exist in the cache (they've been swept)
  then grab the latest from the database. (Which caches them)
  """
  def latest do
    cached_tenminute_all = case :ets.lookup(@table, :tenminute_all) do
      [{:tenminute_all, val}] -> val
      [] -> update_tenminute_all()
    end
    cached_fifteensec_raintemp = case :ets.lookup(@table, :fifteensec_raintemp) do
      [{:fifteensec_raintemp, val}] -> val
      [] -> update_fifteensec_raintemp()
    end
    cached_fifteensec_wind = case :ets.lookup(@table, :fifteensec_wind) do
      [{:fifteensec_wind, val}] -> val
      [] -> update_fifteensec_wind()
    end

    {:ok, %{
      :tenminute_all => cached_tenminute_all,
      :fifteensec_raintemp => cached_fifteensec_raintemp,
      :fifteensec_wind => cached_fifteensec_wind
    }}
  end

  def get_scale_vals do
    {:ok, fifteenSec_vals} = WeatherMoss.Meteobridge.FifteensecondScaleValues.fetch()
    {:ok, %{fifteenSecond: fifteenSec_vals, tenMinute: %{} } }
  end


  ## GenServer Server
  
  def init(_) do
    # TODO: Should this be a :protected table?
    :ets.new(@table, [:set, :public, :named_table, read_concurrency: true, write_concurrency: false])
    schedule_sweep()
    {:ok, %{}}
  end

  # TODO: If the Meteobridge device inserts slowly, this may run before the next datapoint is inserted, so we may
  # be perpetually 10 minutes behind in our data. Investigate this
  def handle_info(:sweep, state) do
    now = DateTime.utc_now()

    case :ets.lookup(@table, :sweep_tenminute_all_at) do
      [sweep_tenminute_all_at: sweep_target] ->
        if DateTime.compare(now, sweep_target) == :gt, do: delkeys([:tenminute_all, :sweep_tenminute_all_at])
      [] -> :noop
    end

    case :ets.lookup(@table, :sweep_fifteensec_raintemp_at) do
      [sweep_fifteensec_raintemp_at: sweep_target] ->
        if DateTime.compare(now, sweep_target) == :gt, do: delkeys([:fifteensec_raintemp, :sweep_fifteensec_raintemp_at])
      [] -> :noop
    end

    case :ets.lookup(@table, :sweep_fifteensec_wind_at) do
      [sweep_fifteensec_wind_at: sweep_target] ->
        if DateTime.compare(now, sweep_target) == :gt, do: delkeys([:fifteensec_wind, :sweep_fifteensec_wind_at])
      [] -> :noop
    end

    schedule_sweep()
    {:noreply, state}
  end

  ## Internal Methods

  defp schedule_sweep do
    Process.send_after(self(), :sweep, @sweep_after)
  end

  defp delkeys(keys) do
    for k <- keys, do: :ets.delete(@table, k)
  end

  defp update_tenminute_all do
    tenminute_all = WeatherMoss.MeteobridgeRepo.one(from x in WeatherMoss.Meteobridge.Housestation.TenminuteAll, order_by: [desc: x.id], limit: 1)   
    :ets.insert(@table, {:tenminute_all, tenminute_all})
    :ets.insert(@table, {:sweep_tenminute_all_at, DateTime.add(tenminute_all.dateTime, 600)})
    tenminute_all
  end

  defp update_fifteensec_raintemp do
    fifteensec_raintemp = WeatherMoss.MeteobridgeRepo.one(from x in WeatherMoss.Meteobridge.Housestation.FifteensecondRainAndTemp, order_by: [desc: x.id], limit: 1)   
    :ets.insert(@table, {:fifteensec_raintemp, fifteensec_raintemp})
    :ets.insert(@table, {:sweep_fifteensec_raintemp_at, DateTime.add(fifteensec_raintemp.dateTime, 15, :second)})
    fifteensec_raintemp
  end

  defp update_fifteensec_wind do
    fifteensec_wind = WeatherMoss.MeteobridgeRepo.one(from x in WeatherMoss.Meteobridge.Housestation.FifteensecondWind, order_by: [desc: x.id], limit: 1)   
    :ets.insert(@table, {:fifteensec_wind, fifteensec_wind})
    :ets.insert(@table, {:sweep_fifteensec_wind_at, DateTime.add(fifteensec_wind.dateTime, 15)})
    fifteensec_wind
  end

end
