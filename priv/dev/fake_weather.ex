defmodule WeatherMoss.FakeWeather do
  @moduledoc """
  Since we have multiple different weather stations that are all going to be
  reporting the weather, it makes more sense to have a single source of what
  the current fake weather is that they can all pull from.

  Each station will have some small variations from this data, in order to
  appear more realistic, but this data will be the "real" fake weather.

  In order to provide some realism this fake weather runs at a 10-minutes-
  every-10-seconds rate.
  """

#  defstruct fake_time: nil,
#            fake_today: nil,
#            ticks_since_cloudcover_change: nil,
#            ticks_since_wind_event_started: nil,
#            ticks_since_rain_event_started: nil,
#            ticks_without_rain: nil,
#            ticks_since_lightning_event_started: nil,
#            cloudcover_pct: nil,
#            base_illuminance: nil,
#            base_temp_F: nil,
#            illuminance: nil,
#            rain_accumulated_mm: nil,
#            rain_day_accumulated_mm: nil,
#            rain_precip_type: nil,
#            temp_F: nil,
#            humidity_pct: nil,
#            pressure_inHg: nil,
#            uv_index: nil,
#            wm2: nil,
#            wind_dir_deg: nil,
#            wind_speed_mph: nil
#
#
#  @type t :: %__MODULE__{
#               fake_time: Time.t(),
#               fake_today: Map.t(),
#               ticks_since_cloudcover_change: integer(),
#               ticks_since_wind_event_started: integer(),
#               ticks_since_rain_event_started: integer(),
#               ticks_without_rain: integer(),
#               ticks_since_lightning_event_started: integer(),
#               cloudcover_pct: integer(),
#               base_illuminance: integer(),
#               base_temp_F: float(),
#               illuminance: integer(),
#               rain_accumulated_mm: float(),
#               rain_day_accumulated_mm: float(),
#               rain_precip_type: term(), # atom, one of: :none, :rain, :hail, :rain_plus_hail
#               temp_F: float(),
#               humidity_pct: integer(),
#               pressure_inHg: float(),
#               uv_index: float()
#               wm2: integer(),
#               wind_dir_deg: integer(),
#               wind_speed_mph: float(),
#             }

  use GenServer
  require Logger

  #####
  # Non-Genserver public helper functions

  def wind_dir_en(degrees) do
    directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    segmentWidth = 360 / length(directions)

    # Rotate the dial half a segment to counter clockwise, so that "north" covers a full segment width centered on 0 degrees.
    targetDirectionWithOffset = case ((0 - (segmentWidth/2)) + degrees) do
      r when r < 0 -> r+360
      r -> r
    end

    dirIndex =  div(trunc(targetDirectionWithOffset), trunc(segmentWidth))

    Enum.at(directions, dirIndex)
  end


  #####
  # Genserver Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def current() do
    GenServer.call(__MODULE__, {:current})
  end

  #####
  # Genserver Server

  @impl true
  def init(_opts) do
    Process.send_after(self(), :weather_loop, 1000)
    {:ok, %{latest: random_weather()}}
  end

  @impl true
  def handle_info(:weather_loop, state) do
    new_state =
      state.latest
      # First we're going to do any of the monotonically increasing values upon
      # which other values depend.
      |> Map.put(:fake_time, state.latest.fake_time |> Time.add(10, :minute))
      |> Map.put(:ticks_since_cloudcover_change, state.latest.ticks_since_cloudcover_change + 1)
      |> Map.put(:ticks_since_wind_event_started, state.latest.ticks_since_wind_event_started + 1)
      |> Map.put(:ticks_since_lightning_event_started, state.latest.ticks_since_lightning_event_started + 1)
      |> do_tick_weather_changes()

    Process.send_after(self(), :weather_loop, 10_000)
    {:noreply, %{state | latest: new_state}}
  end

  @impl true
  def handle_call({:current}, _from, state) do
    {:reply, state.latest, state}
  end

  #####
  # Top-Level entrypoint functions and helpers
  
  # Generates a new weather object from scratch, not based on any previous data
  defp random_weather() do
    fake_time = Time.new!(Enum.random(0..23), Enum.random(0..5)*10, 0, 0)
    min_temp_F = Enum.random(25..50)
    max_temp_F = min_temp_F + Enum.random(5..30) # Daily temp has to go up and down by at least 5, but not more than 30

    %{}
    |> Map.put(:fake_time, fake_time)
    |> Map.put(:fake_today,
         %{
           # We could randomize these, but for now we're just going to make every day the same.
           sunrise: Time.new!(6, 0, 0, 0),
           sunset: Time.new!(20, 0, 0, 0),
           solar_noon: Time.new!(13, 0, 0, 0),
           # Build some max/min parameters for the day, so we can have a consistent rise/fall
           peak_illuminance: Enum.random(20_000..160_000),
           min_temp_F: min_temp_F,
           max_temp_F: max_temp_F,
           pressure_dir: Enum.random([-1, 0, 1]),
         })
    |> Map.put(:ticks_since_cloudcover_change, 0)
    |> Map.put(:ticks_since_wind_event_started, 0)
    |> Map.put(:ticks_since_rain_event_started, 0)
    |> Map.put(:ticks_without_rain, 0)
    |> Map.put(:ticks_since_lightning_event_started, 0)
    |> Map.put(:rain_day_accumulated_mm, Enum.random(1..10))
    |> do_tick_weather_changes()
  end

  defp do_tick_weather_changes(latest) do
    latest
    # First update any of our overarching state trackers,
    # which depend on the incrementing values before, but upon which the actual
    # data itself will depend.
    |> reset_day_if_needed()
    |> alter_base_illuminance_for_time()
    |> alter_cloudcover()
    |> alter_base_temp_F_for_time()
    |> alter_base_humidity_pct()
    # Now we can updated the actual data fields.
    |> calc_illuminance()
    |> calc_uv_index()
    |> calc_wm2()
    |> calc_rain()
    |> calc_temp_F()
    |> calc_humidity_pct()
    |> calc_pressure_inHg()
    |> calc_wind()
  end


  #####
  # Functions for changing the "base" values that represent the state of the world and will impact
  # the actual calculated values.

  defp reset_day_if_needed(latest) do
    # A new day means we need to calculate the new min/max values for the day, which our later values
    # are going to depend on.
    if latest.fake_time.hour == 0 and latest.fake_time.minute == 0 do
      new_fake_day =
        latest.fake_today
        |> Map.put(:peak_illuminance, Enum.random(20_000..160_000))
        |> (fn s -> %{s| min_temp_F: s.min_temp_F + (Enum.random(5..15) * Enum.random([-1, 1]))} end).()
        |> (fn s -> %{s| max_temp_F: s.min_temp_F + Enum.random(5..30)} end).()
        |> Map.put(:pressure_direction, Enum.random([-1, 0, 1]))

      latest
      |> Map.put(:fake_today, new_fake_day)
      |> Map.put(:base_humidity_pct, Enum.random(50..60))
      |> Map.put(:rain_day_accumulated_mm, 0)
    else
      latest
    end
  end

  defp alter_base_illuminance_for_time(latest) do
    # Builds the current base illuminance. If state.fake_time is before state.fake_today.sunrise, then it will be 0,
    # after which it will grow steadily to the state.fake_today.peak_illuminance value at state.fake_today.solar_noon,
    # and then fall steadily back to zero at state.fake_today.sunset.
    base_illuminance = case latest.fake_time do
      time when time < latest.fake_today.sunrise -> 0
      time when time < latest.fake_today.solar_noon -> (latest.fake_today.peak_illuminance / (Time.diff(latest.fake_today.solar_noon, latest.fake_today.sunrise, :minute)/10)) * (Time.diff(latest.fake_today.sunrise, time, :minute)/10) # ((peak illuminance at noon) / (number of steps between sunrise and noon)) * (Number of steps since sunrise)
      time when time < latest.fake_today.sunset -> (latest.fake_today.peak_illuminance / (Time.diff(latest.fake_today.sunset, latest.fake_today.solar_noon, :minute)/10)) * (Time.diff(latest.fake_today.solar_noon, time, :minute)/10) # ((peak illuminance at noon) / (number of steps between noon and sunset)) * (Number of steps since noon)
      _ -> 0
    end

    # Finally, we'll add the illuminance to the state and return the modified state.
    latest
    |> Map.put(:base_illuminance, base_illuminance)
  end

  defp alter_base_temp_F_for_time(latest) do
    # Calculate a base_temp_F.
    # If the current state.fake_time is before state.fake_today.sunrise, then the temp should continue dropping to, but
    # not past, state.fake_today.min_temp_F.
    # After state.fake_today.sunrise the temp should rise consistently until it reaches state.fake_today.max_temp_F at
    # 2 hours before state.fake_today.sunset, after which in should fall consistently until sunrise.
    peak_temp_time = latest.fake_today.sunset |> Time.add(-2, :hour)
    cur = Map.get(latest, :base_temp_F, Enum.random(latest.fake_today.min_temp_F..latest.fake_today.max_temp_F))
    diff_per_tick = case latest.fake_time do
      time when time < latest.fake_today.sunrise ->
        ticks_to_sunrise = Time.diff(latest.fake_today.sunrise, latest.fake_time, :minute)/10
        (cur - latest.fake_today.min_temp_F) / ticks_to_sunrise
      time when time < peak_temp_time ->
        ticks_to_peak = Time.diff(peak_temp_time, latest.fake_time, :minute)/10
        (cur + latest.fake_today.max_temp_F) / ticks_to_peak
      time when time > peak_temp_time ->
        ticks_to_midnight = Time.diff(Time.new!(0,0,0,0), latest.fake_time, :minute)/10
        (cur - latest.fake_today.min_temp_F) / ticks_to_midnight
      _ ->
        Logger.error("altering base_temp_F hit a snag. This was the fault of the programmer.")
        0
    end

    latest
    |> Map.put(:base_temp_F, cur + diff_per_tick)
  end

  defp alter_base_humidity_pct(latest) do
    initial = Map.get(latest, :base_humidity_pct, Enum.random(50..60))

    #TODO: Randomize change here, based on.... ?

    latest
    |> Map.put(:base_humidity_pct, initial)
  end

  defp alter_cloudcover(latest) do
    r = %{
      cloudcover_pct: Map.get(latest, :cloudcover_pct, Enum.random(0..100)),
      ticks_since_cloudcover_change: latest.ticks_since_cloudcover_change
    }
    randomly_change_after = Enum.random(10..20)

    r = case r.ticks_since_cloudcover_change do
      ticks when ticks > randomly_change_after ->
        %{
          cloudcover_pct: add_random_with_limit(r.cloudcover_pct, 45..85, 0..100),
          ticks_since_cloudcover_change: 0
        }
      _ticks ->
        %{
          cloudcover_pct: add_random_with_limit(r.cloudcover_pct, [-10, -5, 0, 5, 10], 0..100),
          ticks_since_cloudcover_change: r.ticks_since_cloudcover_change+1
        }
    end

    Map.merge(latest, r)
  end


  #####
  # These functions are the ones that actually calculate the "true" values for the current weather.

  defp calc_illuminance(latest) do
    # Calculate the true current illuminance value, based on the base_illuminance and the cloudcover_pct.
    # (If the cloudcover is 100, the illuminance should be reduced by half.)
    latest
    |> Map.put(:illuminance, latest.base_illuminance * ((1 - (latest.cloudcover_pct / 100)) * 0.5))
  end

  defp calc_uv_index(latest) do
    latest
    |> Map.put(:uv_index, uv_from_illuminance(latest.illuminance))
  end

  defp calc_wm2(latest) do
    latest
    |> Map.put(:wm2, wm2_from_illuminance(latest.illuminance))
  end

  defp calc_rain(latest) do
    # This represents the amount of rain that has been accumulated since the last tick.
    # Rain is going to depend on a few things:
    # 1) Cloudcover PCT.
    #   A) If < 25, no rain possible.
    #   B) If < 50, rain only up to a certain rate possible
    # 2) Is it currently raining? 
    # 3) Number of ticks since last rain event
    # 4) Temperature. Is it hailing, or snowing?
    #     NOTE: Neither weather station specifically detects "snow"

    # Wikipedia: 
    # Light rain describes rainfall which falls at a rate of between
    # a trace and 2.5 millimetres (0.098 in) per hour.
    # Moderate rain describes rainfall with a precipitation rate of between
    # 2.6 millimetres (0.10 in) and 7.6 millimetres (0.30 in) per hour.
    # Heavy rain describes rainfall with a precipitation rate above
    # 7.6 millimetres (0.30 in) per hour, and violent rain has a
    # rate more than 50 millimetres (2.0 in) per hour.[11]

    # Max rain rate is dictated my current cloudcover
    # This is expressed in millimeters per hour, which is NOT the
    # correct unit of measurement per-tick!
    max_rain_rate = case latest.cloudcover_pct do
      cc when cc > 98 -> 30.0
      cc when cc > 75 -> 7.6
      cc when cc > 50 -> 2.6
      cc when cc > 25 -> 0.5
      _ -> 0.0
    end

    prev_accumulation = Map.get(latest, :rain_accumulated_mm, 0)
    prev_precip_type = Map.get(latest, :rain_precip_type, :none)

    # For the sake of being able to test data we're going to make sure that there's never a dry spell
    # or a rain event that lasts too long. We to change states as often as possible, but not so often
    # that we don't also get a chance to see the data changing.
    {accumulation, precip_type, ticks_without_rain, ticks_since_rain_event_started} = cond do
      latest.ticks_without_rain > 12 -> 
        # We've been dry too long, start at a value in the upper half of the current rain rate.
        # TODO: Make it hail occasionally?
        min_rain_rate = max_rain_rate / 2
        new_rain = add_random_with_limit(prev_accumulation, {min_rain_rate, max_rain_rate, 1}, {0, max_rain_rate})
        {new_rain, :rain, latest.ticks_without_rain + 1, 0}
      latest.ticks_since_rain_event_started > 12 ->
        # It's been raining too long, let's stop.
        {0, :none, 0, latest.ticks_since_rain_event_started + 1}
      prev_accumulation > 0 ->
        # No major change, so we make a minor modification to the existing state
        {add_random_with_limit(prev_accumulation, {-0.2, 0.2, 1}, {0, max_rain_rate}), prev_precip_type, 0, latest.ticks_since_rain_event_started + 1}
      true -> 
        # This implies it's not currently raining, and no changes are needed
        {0, :none, 0, latest.ticks_since_rain_event_started + 1}
    end

    latest
    |> Map.put(:ticks_since_rain_event_started, ticks_since_rain_event_started)
    |> Map.put(:ticks_without_rain, ticks_without_rain)
    |> Map.put(:rain_accumulated_mm, accumulation)
    |> Map.put(:rain_day_accumulated_mm, Map.get(latest, :rain_day_accumulated_mm) + accumulation)
    |> Map.put(:rain_precip_type, precip_type)
  end

  defp calc_temp_F(latest) do
    # Made up non-scientific values indicating how much cloudcover impacts temperature.
    cloudcover_temp_F_modifier = case latest.cloudcover_pct do
      c when c > 90 -> 0.5
      c when c > 75 -> 0.4
      c when c > 50 -> 0.25
      c when c > 10 -> 0.1
      _c -> 0
    end

    latest
    |> Map.put(:temp_F, latest.base_temp_F * cloudcover_temp_F_modifier)
  end

  defp calc_humidity_pct(latest) do
    initial = Map.get(latest, :base_humidity_pct, Enum.random(50..60))
    cloudcover_contribution = Float.round(latest.cloudcover_pct * 0.2, 2)
    # TODO: rain_contribution = ...

    latest
    |> Map.put(:humidity_pct, initial + cloudcover_contribution)
  end

  defp calc_pressure_inHg(latest) do
    initial = Map.get(latest, :pressure_inHg, 30.0)

    latest
    |> Map.put(:pressure_inHg, initial + ((Enum.random(0..10) * 0.01) * latest.fake_today.pressure_dir))
  end

  defp calc_wind(latest) do
    # Once we've hit 40 ticks we want to introduce some randomness
    # to prevent the event from happening EXACTLY every 40 ticks.
    new_event_target_tick = Enum.random(50..70)
    event_length_ticks = Enum.random(15..25)
    cur_dir_deg = Map.get(latest, :wind_dir_deg, Enum.random(1..360))

    {new_ticks_since_last_event, new_wind_speed_mph, new_wind_deg} = case latest.ticks_since_wind_event_started do
      tick when tick >= new_event_target_tick ->
        {0, add_random_with_limit(15.0, {1.0, 10.0, 2}, 15..50), Enum.random(1..360)}
      tick when tick >= event_length_ticks ->
        {tick + 1, add_random_with_limit(2.5, {-1.0, 1.0, 2}, 0..50), degree_change_within_limit(cur_dir_deg, 5)}
      tick ->
        {tick + 1, add_random_with_limit(tick, {-1.0, 1.0, 2}, 0..50), degree_change_within_limit(cur_dir_deg, 15)}
    end
    
    latest
    |> Map.put(:wind_dir_deg, new_wind_deg)
    |> Map.put(:wind_speed_mph, new_wind_speed_mph)
    |> Map.put(:ticks_since_wind_event_started, new_ticks_since_last_event)
  end


  #####
  # Helper functions that are used by the above functions

  # This iteration of the function can accept a random_from function that returns either a number or a range.
  # If it returns a number, it will be added to the base value and then checked against the limit_range.
  # If it returns a range, it will randomly pick a value from that range and then add it to the base value and then check against the limit_range.
  # It is a limitation that we're using ranges, so we can only limit inside integer ranges, but that should be fine for the use-case.
  defp add_random_with_limit(base, random_fun, %Range{} = limit_range) when is_function(random_fun) do
    rnd = random_fun.()
    add_random_with_limit(base, rnd, limit_range)
  end
  defp add_random_with_limit(base, random_from, %Range{} = limit_range) when is_list(random_from) do
    rand_val = Enum.random(random_from)
    add_random_with_limit(base, rand_val, limit_range)
  end
  defp add_random_with_limit(base, %Range{} = random_range, %Range{} = limit_range) do
    rand_val = Enum.random(random_range)
    add_random_with_limit(base, rand_val, limit_range)
  end
  # These versions accepts an input tuple that allows us to define a range, generate a float within that range, and round to given decimal precision.
  defp add_random_with_limit(base, {rand_start, rand_end, decimal_places}, %Range{} = limit_range) do
    add_random_with_limit(base, {rand_start, rand_end, decimal_places}, {limit_range.first, limit_range.last})
  end
  defp add_random_with_limit(base, {rand_start, rand_end, decimal_places}, {low_limit, high_limit}) do # I'd rather have a variable limit_tuple here, but then the pattern match isn't as restrictive, so...
    rand_val = Float.round(:rand.uniform() * (rand_end - rand_start) + rand_start, decimal_places)
    add_random_with_limit(base, rand_val, {low_limit, high_limit})
  end
  # Note that this is the final fall-through of the function, and does not actually do anything random, just adds and checks.
  defp add_random_with_limit(base, chosen_random_value, %Range{} = limit_range) when is_number(chosen_random_value) do
    add_random_with_limit(base, chosen_random_value, {limit_range.first, limit_range.last})
  end
  defp add_random_with_limit(base, chosen_random_value, {low_limit, high_limit}) when is_number(chosen_random_value) do
    res = base + chosen_random_value
    case res do
      val when val < low_limit -> low_limit
      val when val > high_limit -> high_limit
      val -> val
    end
  end

  defp degree_change_within_limit(cur_deg, deg_limit) do
    case cur_deg + Enum.random(-deg_limit..deg_limit) do
      d when d > 360 -> d - 360
      d when d < 1 -> d + 360
      d -> d
    end
  end

  defp calculate_slope_intercept(xs, ys) do
    # Return a tuple of {slope, intercept} for the given xs and ys
    # For now, assume that xs and ys are the same length
    n = length(xs)
    sum_x = Enum.sum(xs)
    sum_y = Enum.sum(ys)
    sum_xy = Enum.zip(xs, ys) |> Enum.reduce(0, fn {x, y}, acc -> acc + x * y end)
    sum_x2 = Enum.reduce(xs, 0, fn x, acc -> acc + x * x end)

    slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x)
    intercept = (sum_y - slope * sum_x) / n

    {slope, intercept}
  end

  defp uv_from_illuminance(illuminance) do
    # Some values based on the VC weather station:
    illuminances = [2537, 11441, 62558, 97850, 125_000, 146_000]
    uvs = [2.8, 3.8, 5.8, 7.8, 9, 10]
    {m, b} = calculate_slope_intercept(illuminances, uvs)
    m * illuminance + b
  end

  defp wm2_from_illuminance(illuminance) do
    # Some values based on the VC weather station:
    illuminances = [2537, 11441, 62558, 97850, 125_000, 146_000]
    wm2s = [51, 258, 522, 816, 1044, 1217]
    {m, b} = calculate_slope_intercept(illuminances, wm2s)
    m * illuminance + b
  end

end
