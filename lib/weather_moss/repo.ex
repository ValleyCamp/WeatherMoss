defmodule WeatherMoss.Repo do
  use Ecto.Repo,
    otp_app: :weather_moss,
    adapter: Ecto.Adapters.Postgres
end
