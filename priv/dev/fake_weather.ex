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
#            ticks_since_lightning_event_started: nil,
#            cloudcover_pct: nil,
#            base_illuminance: nil,
#            base_temp_F: nil,
#            illuminance: nil,
#            temp_F: nil,
#            humidity_pct: nil,
#            pressure_inHg: nil,
#            uv_index: nil,
#            wm2: nil
#
#
#  @type t :: %__MODULE__{
#               fake_time: Time.t(),
#               fake_today: Map.t(),
#               ticks_since_cloudcover_change: integer(),
#               ticks_since_wind_event_started: integer(),
#               ticks_since_rain_event_started: integer(),
#               ticks_since_lightning_event_started: integer(),
#               cloudcover_pct: integer(),
#               base_illuminance: integer(),
#               base_temp_F: float(),
#               illuminance: integer(),
#               temp_F: float(),
#               humidity_pct: integer(),
#               pressure_inHg: float(),
#               uv_index: float()
#               wm2: integer(),
#             }

  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

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
      |> Map.put(:ticks_since_wind_event_started, state.latest.ticks_since_wind_event_started +1)
      |> Map.put(:ticks_since_rain_event_started, state.latest.ticks_since_rain_event_started + 1)
      |> Map.put(:ticks_since_lightning_event_started, state.latest.ticks_since_lightning_event_started + 1)
      # Next we're going to update any of our overarching state trackers,
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

    Process.send_after(self(), :weather_loop, 10_000)
    {:noreply, %{state | latest: new_state}}
  end

  @impl true
  def handle_call(:get_weather, _from, state) do
    {:reply, state.latest, state}
  end

  # Generates a new weather object from scratch, not based on any previous data
  defp random_weather() do
    fake_time = Time.new(Enum.random(0..23), Enum.random(0..5)*10, 0, 0)
    min_temp_F = Enum.random(25..50)
    max_temp_F = min_temp_F + Enum.random(5..30) # Daily temp has to go up and down by at least 5, but not more than 30

    %{}
    |> Map.put(:fake_time, fake_time)
    |> Map.put(:fake_today,
         %{
           # We could randomize these, but for now we're just going to make every day the same.
           sunrise: Time.new(6, 0, 0, 0),
           sunset: Time.new(20, 0, 0, 0),
           solar_noon: Time.new(13, 0, 0, 0),
           # Build some max/min parameters for the day, so we can have a consistent rise/fall
           peak_illuminance: Enum.random(20_000..160_000),
           min_temp_F: min_temp_F,
           max_temp_F: max_temp_F,
           pressure_dir: Enum.random([-1, 0, 1]),
         })
    |> Map.put(:ticks_since_cloudcover_change, 0)
    |> Map.put(:ticks_since_wind_event_started, 0)
    |> Map.put(:ticks_since_rain_event_started, 0)
    |> Map.put(:ticks_since_lightning_event_started, 0)
    |> Map.put(:cloudcover_pct, Enum.random(0..100))
    |> alter_base_illuminance_for_time()
    |> alter_cloudcover()
    |> alter_base_temp_F_for_time()
    |> alter_base_humidity_pct()
    |> calc_illuminance()
    |> calc_uv_index()
    |> calc_wm2()
    |> calc_rain()
    |> calc_temp_F()
    |> calc_humidity_pct()
    |> calc_pressure_inHg()
  end

  # This iteration of the function can accept a random_from function that returns either a number or a range.
  # If it returns a number, it will be added to the base value and then checked against the limit_range.
  # If it returns a range, it will randomly pick a value from that range and then add it to the base value and then check against the limit_range.
  defp add_random_with_limit(base, random_fun, limit_range) when is_function(random_fun) do
    rnd = random_fun.()
    add_random_with_limit(base, rnd, limit_range)
  end
  defp add_random_with_limit(base, random_from, limit_range) when is_list(random_from) do
    rand_val = Enum.random(random_from)
    add_random_with_limit(base, rand_val, limit_range)
  end
  defp add_random_with_limit(base, {rand_start, rand_end, decimal_places}, limit_range) do
    rand_val = Float.round(:rand.uniform() * (rand_end - rand_start) + rand_start, decimal_places)
    add_random_with_limit(base, rand_val, limit_range)
  end
  # Note that this is the final fall-through of the function, and does not actually do anything random, just adds and checks.
  defp add_random_with_limit(base, chosen_random_value, limit_range) when is_number(chosen_random_value) do
    res = base + chosen_random_value
    case res do
      val when val < limit_range.min -> limit_range.min
      val when val > limit_range.max -> limit_range.max
      val -> val
    end
  end

  defp reset_day_if_needed(state) do
    # A new day means we need to calculate the new min/max values for the day, which our later values
    # are going to depend on.
    if state.fake_time.hour == 0 and state.fake_time.minute == 0 do
      new_fake_day =
        state.fake_today
        |> Map.put(:peak_illuminance, Enum.random(20_000..160_000))
        |> (fn s -> %{s| min_temp_F: s.min_temp_F + (Enum.random(5..15) * Enum.random([-1, 1]))} end).()
        |> (fn s -> %{s| max_temp_F: s.min_temp_F + Enum.random(5..30)} end).()
        |> Map.put(:pressure_direction, Enum.random([-1, 0, 1]))

        %{state| fake_today: new_fake_day,
                 base_humidity_pct: Enum.random(50..60)}
    else
      state
    end
  end

  defp alter_base_illuminance_for_time(state) do
    # Builds the current base illuminance. If state.fake_time is before state.fake_today.sunrise, then it will be 0,
    # after which it will grow steadily to the state.fake_today.peak_illuminance value at state.fake_today.solar_noon,
    # and then fall steadily back to zero at state.fake_today.sunset.
    base_illuminance = case state.fake_time do
      time when time < state.fake_today.sunrise -> 0
      time when time < state.fake_today.solar_noon -> (time - state.fake_today.sunrise) / (state.fake_today.solar_noon - state.fake_today.sunrise) * state.fake_today.peak_illuminance
      time when time < state.fake_today.sunset -> (time - state.fake_today.sunset) / (state.fake_today.solar_noon - state.fake_today.sunrise) * state.fake_today.peak_illuminance
      _ -> 0
    end

    # Finally, we'll add the illuminance to the state and return the modified state.
    %{state| base_illuminance: base_illuminance}
  end

  defp alter_base_temp_F_for_time(state) do
    # Calculate a base_temp_F.
    # If the current state.fake_time is before state.fake_today.sunrise, then the temp should continue dropping to, but
    # not past, state.fake_today.min_temp_F.
    # After state.fake_today.sunrise the temp should rise consistently until it reaches state.fake_today.max_temp_F at
    # 2 hours before state.fake_today.sunset, after which in should fall consistently until sunrise.
    peak_temp_time = state.fake_today.sunset |> Time.add(-2, :hour)
    diff_per_tick = case state.fake_time do
      time when time < state.fake_today.sunrise ->
        ticks_to_sunrise = Time.diff(state.fake_today.sunrise, state.fake_time, :minute)/10
        (state.temp_F - state.fake_today.min_temp_F) / ticks_to_sunrise
      time when time < peak_temp_time ->
        ticks_to_peak = Time.diff(peak_temp_time, state.fake_time, :minute)/10
        (state.temp_F + state.fake_today.max_temp_F) / ticks_to_peak
      time when time > peak_temp_time ->
        ticks_to_midnight = Time.diff(Time.new(0,0,0,0), state.fake_time, :minute)/10
        (state.temp_F - state.fake_today.min_temp_F) / ticks_to_midnight
      _ ->
        Logger.error("altering base_temp_F hit a snag. This was the fault of the programmer.")
        0
    end

    %{state| base_temp_F: state.base_temp_F + diff_per_tick}
  end

  defp alter_base_humidity_pct(state) do
    # TODO: !!
    state
  end

  defp alter_cloudcover(state) do
    r = %{
      cloudcover_pct: state.cloudcover_pct,
      ticks_since_cloudcover_change: state.ticks_since_cloudcover_change
    }
    randomly_change_after = Enum.random(10..20)

    r = case r.ticks_since_cloudcover_change do
      count when count > randomly_change_after ->
        %{
          cloudcover_pct: add_random_with_limit(r.cloudcover_pct, 45..85, 0..100),
          ticks_since_cloudcover_change: 0
        }
      count ->
        %{
          cloudcover_pct: add_random_with_limit(r.fake_cloudcover_pct, [-10, -5, 0, 5, 10], 0..100),
          ticks_since_cloudcover_change: r.ticks_since_cloudcover_change+1
        }
    end

    Map.merge(state, r)
  end

  #####
  # These functions are the ones that actually calculate the "true" values for the current weather.

  defp calc_illuminance(state) do
    # Calculate the true current illuminance value, based on the base_illuminance and the cloudcover_pct.
    # (If the cloudcover is 100, the illuminance should be reduced by half.)
    %{state| illuminance: state.base_illuminance * ((1 - (state.cloudcover_pct / 100)) * 0.5)}
  end

  defp calc_uv_index(state) do
    %{state| uv_index: uv_from_illuminance(state.illuminance)}
  end

  defp calc_wm2(state) do
    %{state| wm2: wm2_from_illuminance(state.illuminance)}
  end

  defp calc_rain(state) do
    state
  end

  defp calc_temp_F(state) do
    # Made up non-scientific values indicating how much cloudcover impacts temperature.
    cloudcover_temp_F_modifier = case state.cloudcover_pct do
      c when c > 90 -> 0.5
      c when c > 75 -> 0.4
      c when c > 50 -> 0.25
      c when c > 10 -> 0.1
      _c -> 0
    end

    %{state| temp_F: state.base_temp_F * cloudcover_temp_F_modifier}
  end

  defp calc_humidity_pct(state) do
    initial = state.base_humidity_pct || Enum.random(50..60)
    cloudcover_contribution = Float.round(state.cloudcover_pct * 0.2, 2)
    # TODO: rain_contribution = ...
    %{state| humidity_pct: initial + cloudcover_contribution}
  end

  defp calc_pressure_inHg(state) do
    initial = state.pressure_inHg || 30.0
    %{state| pressure_inHg: initial + ((Enum.random(0..10) * 0.01) * state.fake_today.pressure_dir)}
  end

  #####
  # Helper functions that are used by the above functions

  defp calculate_slope_intercept(xs, ys) do
    # Return a tuple of {slope, intercept} for the given xs and ys
    # For now, assume that xs and ys are the same length
    #n = length(xs)
    #x_mean = Enum.sum(xs) / n
    #y_mean = Enum.sum(ys) / n
    #x_mean_sq = x_mean * x_mean
    #x_mean_y_mean = x_mean * y_mean
    #x_sq_mean = Enum.sum(Enum.map(xs, fn x -> x * x end)) / n
    #x_sum_y_sum = Enum.sum(Enum.map(xs, fn x -> x * y end)) / n

    #slope = (x_sum_y_sum - x_mean_y_mean) / (x_sq_mean - x_mean_sq)
    #intercept = y_mean - (slope * x_mean)
    
    sum_x = Enum.sum(xs)
    sum_y = Enum.sum(ys)
    sum_xy = Enum.zip(xs, ys) |> Enum.map(fn {x,y} -> x*y end) |> Enum.sum()
    sum_x2 = Enum.map(xs, fn x -> :math.pow(x, 2) end) |> Enum.sum()
    sum_y2 = Enum.map(ys, fn y -> :math.pow(y, 2) end) |> Enum.sum()
    n = length(xs)
    slope = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - :math.pow(sum_x, 2))
    intercept = (sum_y - slope * sum_x)

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
