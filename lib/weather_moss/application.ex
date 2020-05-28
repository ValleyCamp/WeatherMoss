defmodule WeatherMoss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository for the Meteobridge DB
      WeatherMoss.MeteobridgeRepo,
      # Start the Telemetry supervisor
      WeatherMossWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: WeatherMoss.PubSub},
      # Start the Endpoint (http/https)
      WeatherMossWeb.Endpoint,
      # Start a worker by calling: WeatherMoss.Worker.start_link(arg)
      # {WeatherMoss.Worker, arg}
      WeatherMoss.Meteobridge
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WeatherMoss.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    WeatherMossWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
