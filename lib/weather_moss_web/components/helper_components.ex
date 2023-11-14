defmodule WeatherMossWeb.HelperComponents do
  @moduledoc """
  Provides helper components and formatting functions.

  Kept separate here in order to be able to keep CoreComponents as phoenix standard.
  """
  use Phoenix.Component
  use Timex
  #alias Phoenix.LiveView.JS
  #import WeatherMossWeb.Gettext

  def datetime_format(datetime) do
    Timezone.convert(datetime, Application.get_env(:weather_moss, :site_tz))
    |> Timex.format!("%H:%M:%S, %D", :strftime)
  end

end
