# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :weather_moss,
  ecto_repos: [WeatherMoss.MeteobridgeRepo]

# Configures the endpoint
config :weather_moss, WeatherMossWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PKG8mfIq4FUU1wrwgWGTxl9d9yWOquYapV87zRapzKUZes8rRl4E+vzEu8itFpd0",
  render_errors: [view: WeatherMossWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: WeatherMoss.PubSub,
  live_view: [signing_salt: "zRF/CEie"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
