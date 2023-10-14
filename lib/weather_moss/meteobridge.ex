defmodule WeatherMoss.Meteobridge do
  @moduledoc """
  The Meteobridge context.
  """

  import Ecto.Query, warn: false
  alias WeatherMoss.Repo

  alias WeatherMoss.Meteobridge.TenMinuteObservation

  @doc """
  Returns the list of meteobridge_ten_minute_observations.

  ## Examples

      iex> list_meteobridge_ten_minute_observations()
      [%TenMinuteObservation{}, ...]

  """
  def list_meteobridge_ten_minute_observations do
    Repo.all(TenMinuteObservation)
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
  Updates a ten_minute_observation.

  ## Examples

      iex> update_ten_minute_observation(ten_minute_observation, %{field: new_value})
      {:ok, %TenMinuteObservation{}}

      iex> update_ten_minute_observation(ten_minute_observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ten_minute_observation(%TenMinuteObservation{} = ten_minute_observation, attrs) do
    ten_minute_observation
    |> TenMinuteObservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ten_minute_observation.

  ## Examples

      iex> delete_ten_minute_observation(ten_minute_observation)
      {:ok, %TenMinuteObservation{}}

      iex> delete_ten_minute_observation(ten_minute_observation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ten_minute_observation(%TenMinuteObservation{} = ten_minute_observation) do
    Repo.delete(ten_minute_observation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ten_minute_observation changes.

  ## Examples

      iex> change_ten_minute_observation(ten_minute_observation)
      %Ecto.Changeset{data: %TenMinuteObservation{}}

  """
  def change_ten_minute_observation(%TenMinuteObservation{} = ten_minute_observation, attrs \\ %{}) do
    TenMinuteObservation.changeset(ten_minute_observation, attrs)
  end

  alias WeatherMoss.Meteobridge.FifteenSecondObservation

  @doc """
  Returns the list of meteobridge_fifteen_second_observations.

  ## Examples

      iex> list_meteobridge_fifteen_second_observations()
      [%FifteenSecondObservation{}, ...]

  """
  def list_meteobridge_fifteen_second_observations do
    Repo.all(FifteenSecondObservation)
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
  Updates a fifteen_second_observation.

  ## Examples

      iex> update_fifteen_second_observation(fifteen_second_observation, %{field: new_value})
      {:ok, %FifteenSecondObservation{}}

      iex> update_fifteen_second_observation(fifteen_second_observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fifteen_second_observation(%FifteenSecondObservation{} = fifteen_second_observation, attrs) do
    fifteen_second_observation
    |> FifteenSecondObservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fifteen_second_observation.

  ## Examples

      iex> delete_fifteen_second_observation(fifteen_second_observation)
      {:ok, %FifteenSecondObservation{}}

      iex> delete_fifteen_second_observation(fifteen_second_observation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fifteen_second_observation(%FifteenSecondObservation{} = fifteen_second_observation) do
    Repo.delete(fifteen_second_observation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fifteen_second_observation changes.

  ## Examples

      iex> change_fifteen_second_observation(fifteen_second_observation)
      %Ecto.Changeset{data: %FifteenSecondObservation{}}

  """
  def change_fifteen_second_observation(%FifteenSecondObservation{} = fifteen_second_observation, attrs \\ %{}) do
    FifteenSecondObservation.changeset(fifteen_second_observation, attrs)
  end

  alias WeatherMoss.Meteobridge.StartOfDayObservation

  @doc """
  Returns the list of meteobridge_start_of_day_observations.

  ## Examples

      iex> list_meteobridge_start_of_day_observations()
      [%StartOfDayObservation{}, ...]

  """
  def list_meteobridge_start_of_day_observations do
    Repo.all(StartOfDayObservation)
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
  Updates a start_of_day_observation.

  ## Examples

      iex> update_start_of_day_observation(start_of_day_observation, %{field: new_value})
      {:ok, %StartOfDayObservation{}}

      iex> update_start_of_day_observation(start_of_day_observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_start_of_day_observation(%StartOfDayObservation{} = start_of_day_observation, attrs) do
    start_of_day_observation
    |> StartOfDayObservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a start_of_day_observation.

  ## Examples

      iex> delete_start_of_day_observation(start_of_day_observation)
      {:ok, %StartOfDayObservation{}}

      iex> delete_start_of_day_observation(start_of_day_observation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_start_of_day_observation(%StartOfDayObservation{} = start_of_day_observation) do
    Repo.delete(start_of_day_observation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking start_of_day_observation changes.

  ## Examples

      iex> change_start_of_day_observation(start_of_day_observation)
      %Ecto.Changeset{data: %StartOfDayObservation{}}

  """
  def change_start_of_day_observation(%StartOfDayObservation{} = start_of_day_observation, attrs \\ %{}) do
    StartOfDayObservation.changeset(start_of_day_observation, attrs)
  end

  alias WeatherMoss.Meteobridge.EndOfDayObservation

  @doc """
  Returns the list of meteobridge_end_of_day_observations.

  ## Examples

      iex> list_meteobridge_end_of_day_observations()
      [%EndOfDayObservation{}, ...]

  """
  def list_meteobridge_end_of_day_observations do
    Repo.all(EndOfDayObservation)
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

  @doc """
  Updates a end_of_day_observation.

  ## Examples

      iex> update_end_of_day_observation(end_of_day_observation, %{field: new_value})
      {:ok, %EndOfDayObservation{}}

      iex> update_end_of_day_observation(end_of_day_observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_end_of_day_observation(%EndOfDayObservation{} = end_of_day_observation, attrs) do
    end_of_day_observation
    |> EndOfDayObservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a end_of_day_observation.

  ## Examples

      iex> delete_end_of_day_observation(end_of_day_observation)
      {:ok, %EndOfDayObservation{}}

      iex> delete_end_of_day_observation(end_of_day_observation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_end_of_day_observation(%EndOfDayObservation{} = end_of_day_observation) do
    Repo.delete(end_of_day_observation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking end_of_day_observation changes.

  ## Examples

      iex> change_end_of_day_observation(end_of_day_observation)
      %Ecto.Changeset{data: %EndOfDayObservation{}}

  """
  def change_end_of_day_observation(%EndOfDayObservation{} = end_of_day_observation, attrs \\ %{}) do
    EndOfDayObservation.changeset(end_of_day_observation, attrs)
  end
end
