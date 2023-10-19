defmodule WeatherMoss.Meteobridge do
  @moduledoc """
  The Meteobridge context.
  """

  import Ecto.Query, warn: false
  alias WeatherMoss.Repo
  alias WeatherMoss.Meteobridge.{FifteenSecondObservation,TenMinuteObservation,StartOfDayObservation,EndOfDayObservation}

  @doc """
  Returns the last n meteobridge_ten_minute_observations for a given station. (defaults to 48, or 8 hours worth)
  For the sake of completeness will return the most recent observations from any station if no station is provided.
  Note that in this case the data is not guaranteed to be 8 hours worth, since you may have 2 stations recording events
  which would mean 48 events is just 4 hours.

  ## Examples

      iex> recent_ten_minute_observations("fake-dev-station")
      [%TenMinuteObservation{}, ...]

  """
  def recent_ten_minute_observations(station \\ nil, limit \\ 48) do
    case station do
      nil -> TenMinuteObservation
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
      stn -> TenMinuteObservation
             |> where([o], o.station == ^stn)
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
    end
  end

  @doc """
  Gets a single ten_minute_observation.

  Raises `Ecto.NoResultsError` if the Ten minute observation does not exist.

  ## Examples

      iex> get_ten_minute_observation!(123)
      %TenMinuteObservation{}

      iex> get_ten_minute_observation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ten_minute_observation!(id), do: Repo.get!(TenMinuteObservation, id)

  @doc """
  Creates a ten_minute_observation.

  ## Examples

      iex> create_ten_minute_observation(%{field: value})
      {:ok, %TenMinuteObservation{}}

      iex> create_ten_minute_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ten_minute_observation(attrs \\ %{}) do
    %TenMinuteObservation{}
    |> TenMinuteObservation.changeset(attrs)
    |> Repo.insert()
  end



  @doc """
  Returns the last n meteobridge_fifteen_second_observations for the given station. (Defaults to 240, or 1 hours worth)
  For the sake of completeness will return the most recent observations from any station if no station is provided.
  Note that in this case the data is not guaranteed to be an hours worth, since you may have 2 stations recording events
  which would mean 240 events is just 30 minutes.

  ## Examples

      iex> recent_fifteen_second_observations("fake-dev-station")
      [%FifteenSecondObservation{}, ...]

  """
  def recent_fifteen_second_observations(station \\ nil, limit \\ 240) do
    case station do
      nil -> FifteenSecondObservation
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
      stn -> FifteenSecondObservation
             |> where([o], o.station == ^stn)
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
    end
  end

  @doc """
  Gets a single fifteen_second_observation.

  Raises `Ecto.NoResultsError` if the Fifteen second observation does not exist.

  ## Examples

      iex> get_fifteen_second_observation!(123)
      %FifteenSecondObservation{}

      iex> get_fifteen_second_observation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fifteen_second_observation!(id), do: Repo.get!(FifteenSecondObservation, id)

  @doc """
  Creates a fifteen_second_observation.

  ## Examples

      iex> create_fifteen_second_observation(%{field: value})
      {:ok, %FifteenSecondObservation{}}

      iex> create_fifteen_second_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fifteen_second_observation(attrs \\ %{}) do
    %FifteenSecondObservation{}
    |> FifteenSecondObservation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the last n meteobridge_start_of_day_observations. (Defaults to 7, for the last week)
  For the sake of completeness will return the most recent observations from any station if no station is provided.
  Note that in this case the data is not guaranteed to be an hours worth, since you may have 2 stations recording events
  which would mean 7 events is just 3.5 days.

  ## Examples

      iex> recent_start_of_day_observations("fake-dev-station")
      [%StartOfDayObservation{}, ...]

  """
  def recent_start_of_day_observations(station \\ nil, limit \\ 7) do
    case station do
      nil -> StartOfDayObservation
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all
      stn -> StartOfDayObservation
             |> where([o], o.station == ^stn)
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
    end
  end

  @doc """
  Gets a single start_of_day_observation.

  Raises `Ecto.NoResultsError` if the Start of day observation does not exist.

  ## Examples

      iex> get_start_of_day_observation!(123)
      %StartOfDayObservation{}

      iex> get_start_of_day_observation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_start_of_day_observation!(id), do: Repo.get!(StartOfDayObservation, id)

  @doc """
  Creates a start_of_day_observation.

  ## Examples

      iex> create_start_of_day_observation(%{field: value})
      {:ok, %StartOfDayObservation{}}

      iex> create_start_of_day_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_start_of_day_observation(attrs \\ %{}) do
    %StartOfDayObservation{}
    |> StartOfDayObservation.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the last n meteobridge_end_of_day_observations. (Defaults to 7, for the last week)
  For the sake of completeness will return the most recent observations from any station if no station is provided.
  Note that in this case the data is not guaranteed to be an hours worth, since you may have 2 stations recording events
  which would mean 7 events is just 3.5 days.

  ## Examples

      iex> recent_end_of_day_observations("fake-dev-station")
      [%EndOfDayObservation{}, ...]

  """
  def recent_end_of_day_observations(station \\ nil, limit \\ 7) do
    case station do
      nil -> EndOfDayObservation
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
      stn -> EndOfDayObservation
             |> where([o], o.station == ^stn)
             |> order_by([o], desc: o.inserted_at)
             |> limit(^limit)
             |> Repo.all()
    end
  end

  @doc """
  Gets a single end_of_day_observation.

  Raises `Ecto.NoResultsError` if the End of day observation does not exist.

  ## Examples

      iex> get_end_of_day_observation!(123)
      %EndOfDayObservation{}

      iex> get_end_of_day_observation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_end_of_day_observation!(id), do: Repo.get!(EndOfDayObservation, id)

  @doc """
  Creates a end_of_day_observation.

  ## Examples

      iex> create_end_of_day_observation(%{field: value})
      {:ok, %EndOfDayObservation{}}

      iex> create_end_of_day_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_end_of_day_observation(attrs \\ %{}) do
    %EndOfDayObservation{}
    |> EndOfDayObservation.changeset(attrs)
    |> Repo.insert()
  end

end
