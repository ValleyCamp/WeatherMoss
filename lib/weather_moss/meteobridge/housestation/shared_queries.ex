# Since there are some common features between the meteobridge housestation tables we can share some common queries between them
defmodule WeatherMoss.Meteobridge.Housestation.SharedQueries do
  defmacro __using__(_opts) do
    quote do 
      import Ecto.Query

      def in_last_day(query) do
        dayago = DateTime.utc_now
                |> DateTime.add(-86400, :second) # 60*60*24

        from r in query,
          where: r.dateTime >= ^dayago
      end

      def in_last_month(query) do
        monthago = DateTime.utc_now
                |> DateTime.add(-26784000, :second) # 60*60*24*31

        from r in query,
          where: r.dateTime >= ^monthago
      end
    end
  end
end


defmodule WeatherMoss.Meteobridge.Housestation.SharedRainAndTempQueries do
  import Ecto.Query
  defmacro __using__(_opts) do
    quote do
      import Ecto.Query

      def max_rain_rate(query) do
        from r in query,
          select: max(r.rainRateCur)
      end

      def max_daily_rain(query) do
        from r in query,
          select: max(r.rainDay)
      end

      def min_temp(query) do
        from r in query,
          select: min(r.tempOutCur)
      end

      def max_temp(query) do
        from r in query,
          select: max(r.tempOutCur)
      end
    end
  end
end
