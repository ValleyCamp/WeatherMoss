defmodule WeatherMoss.MeteobridgeRepo do
  use Ecto.Repo,
    otp_app: :weather_moss,
    adapter: Ecto.Adapters.MyXQL
end
