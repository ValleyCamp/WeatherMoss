defmodule WeatherMossWeb.ViewHelpers do
  @moduledoc """
  Generic helpers used across all views
  """
  
  use Phoenix.HTML
  use Timex

  @doc """
  Format a DateTime into the preferred format, in the Timezone set in the the :site_tz config
  """
  def datetime_format(datetime) do
    Timezone.convert(datetime, Application.get_env(:weather_moss, :site_tz))
    |> Timex.format!("%H:%M:%S, %D", :strftime)
  end
end
