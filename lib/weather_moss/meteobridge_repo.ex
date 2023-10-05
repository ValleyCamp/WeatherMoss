defmodule WeatherMoss.MeteobridgeRepo do
  use Ecto.Repo,
    otp_app: :weather_moss,
    adapter: Ecto.Adapters.MyXQL
    #read_only: true # We can't be read-only to use the fake-event-emitter for testing/development
end
