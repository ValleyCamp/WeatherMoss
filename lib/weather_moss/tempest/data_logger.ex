defmodule WeatherMoss.Tempest.DataLogger do
  @moduledoc """
    Takes the data from any Tempest device it hears on the network and saves
    the data to a database.
  """
  use GenServer
  alias WeatherMoss.Repo
  alias WeatherMoss.Tempest.{EventPrecipitation, RapidWind, EventStrike, ObservationAir, ObservationSky, ObservationTempest}
  require Logger

  ## GenServer Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  ## GenServer Server

  def init(_opts) do
    WeatherflowTempest.PubSub.subscribe_to_udp_events()
    {:ok, %{}}
  end

  def handle_info({{:weatherflow, :event_precipitation}, event_data}, socket) do
    cs = EventPrecipitation.changeset(%EventPrecipitation{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, :event_strike}, event_data}, socket) do
    cs = EventStrike.changeset(%EventStrike{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, :rapid_wind}, event_data}, socket) do
    cs = RapidWind.changeset(%RapidWind{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, :observation_air}, event_data}, socket) do
    cs = ObservationAir.changeset(%ObservationAir{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, :observation_sky}, event_data}, socket) do
    cs = ObservationSky.changeset(%ObservationSky{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, :observation_tempest}, event_data}, socket) do
    cs = ObservationTempest.changeset(%ObservationTempest{}, event_data)
    Repo.insert(cs)
    {:noreply, socket}
  end

  def handle_info({{:weatherflow, event_type}, event_data}, socket) do
    Logger.info("Got a #{event_type} Tempest message: #{inspect event_data}")

    {:noreply, socket}
  end
end
