defmodule WeatherMoss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WeatherMossWeb.Telemetry,
      # Start the Ecto repository for the Meteobridge DB
      WeatherMoss.MeteobridgeRepo,
      # Start the Echo repository for the DB managed by us
      WeatherMoss.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WeatherMoss.PubSub},
      # Start Finch
      {Finch, name: WeatherMoss.Finch},
      # Start the Endpoint (http/https)
      WeatherMossWeb.Endpoint,
      # Start a worker by calling: WeatherMoss.Worker.start_link(arg)
      # {WeatherMoss.Worker, arg}
      WeatherMoss.Scheduler,
      WeatherMoss.Tempest.DataLogger,
      WeatherMoss.MeteobridgeSQL, # Note that this must be the last worker in the list, otherwise the fake emitter will not be inserted before it.
    ]
    |> maybe_insert_fake_emitters

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherMoss.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # The FakeEventEmitter needs to be inserted BEFORE the Meteobridge worker, otherwise things get crashy due to no values existing in a fresh database.
  defp maybe_insert_fake_emitters(children) do
    if Application.get_env(:weather_moss, :enable_fake_meteobridge_emitter) do
      children
      |> List.insert_at(-2, WeatherMoss.FakeMeteobridgeSQLEvents)
      |> List.insert_at(-2, WeatherMoss.FakeMeteobridgeHTTPEvents)
    else
      children
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WeatherMossWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
