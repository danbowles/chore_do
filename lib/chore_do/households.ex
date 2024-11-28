defmodule ChoreDo.Households do
  @moduledoc """
  The Households context.
  """

  import Ecto.Query, warn: false
  alias ChoreDo.Repo

  alias ChoreDo.Households.Household
  alias ChoreDo.Households.Member

  @doc """
  Returns the list of households.

  ## Examples

      iex> list_households()
      [%Household{}, ...]

  """
  def list_households do
    Repo.all(Household)
  end

  def get_household_for_user(user) do
    Household.Query.with_user(user)
    |> Repo.one()
  end

  @doc """
  Creates a member, adds to household

  ## Examples

      iex> add_member(user_id, %ChoreDo.Households.Household{},%{field: value})
      {:ok, %Member{}}

      iex> add_member(user_id, %ChoreDo.Households.Household{},%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_member(user_id, %ChoreDo.Households.Household{} = household, attrs \\ %{}) do
    if is_nil(member_from_user(user_id)) do
      %Member{user_id: user_id, household_id: household.id, role: :admin}
      |> Member.changeset(attrs)
      |> Repo.insert()
    else
      {:error, :already_member}
    end
  end

  @doc """
  Returns a member from a given user.

  ## Examples

    iex> member_from_user(user_id)
    {:ok, %Member{}}

  """
  def member_from_user(user_id) do
    Repo.get_by(Member, user_id: user_id) |> Repo.preload(:user)
  end

  @doc """
  Gets a single household.

  Raises `Ecto.NoResultsError` if the Household does not exist.

  ## Examples

      iex> get_household!(123)
      %Household{}

      iex> get_household!(456)
      ** (Ecto.NoResultsError)

  """
  def get_household!(id), do: Repo.get!(Household, id)

  @doc """
  Create a household with a user as admin

  ## Examples

      iex> create_household_with_admin(user_id, %{field: value})
      {:ok, %Household{}}

      iex> create_household_with_admin(user_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_household_with_admin(user, attrs \\ %{}) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:create_household, fn _repo, _ ->
      create_household(attrs)
    end)
    |> Ecto.Multi.run(:add_member, fn _repo, %{create_household: household} ->
      add_member(user.id, household, %{role: :admin})
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{create_household: household}} -> {:ok, household}
      {:error, :add_member, _changeset, _} -> {:error, :already_member}
      {:error, :create_household, changeset, _} -> {:error, changeset}
    end
  end

  @doc """
  Creates a household.

  ## Examples

      iex> create_household(%{field: value})
      {:ok, %Household{}}

      iex> create_household(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_household(attrs \\ %{}) do
    %Household{}
    |> Household.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a household.

  ## Examples

      iex> update_household(household, %{field: new_value})
      {:ok, %Household{}}

      iex> update_household(household, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_household(%Household{} = household, attrs) do
    household
    |> Household.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a household.

  ## Examples

      iex> delete_household(household)
      {:ok, %Household{}}

      iex> delete_household(household)
      {:error, %Ecto.Changeset{}}

  """
  def delete_household(%Household{} = household) do
    Repo.delete(household)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking household changes.

  ## Examples

      iex> change_household(household)
      %Ecto.Changeset{data: %Household{}}

  """
  def change_household(%Household{} = household, attrs \\ %{}) do
    Household.changeset(household, attrs)
  end

  @doc """
  Returns the list of members.

  ## Examples

      iex> list_members()
      [%Member{}, ...]

  """
  def list_members do
    Repo.all(Member)
  end

  @doc """
  Gets a single member.

  Raises `Ecto.NoResultsError` if the Member does not exist.

  ## Examples

      iex> get_member!(123)
      %Member{}

      iex> get_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_member!(id), do: Repo.get!(Member, id)

  @doc """
  Creates a member.
  TODO: Remove as we will not directly create members like this

  ## Examples

      iex> create_member(%{field: value})
      {:ok, %Member{}}

      iex> create_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_member(attrs \\ %{}) do
    %Member{}
    |> Member.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a member.

  ## Examples

      iex> update_member(member, %{field: new_value})
      {:ok, %Member{}}

      iex> update_member(member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_member(%Member{} = member, attrs) do
    member
    |> Member.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a member.

  ## Examples

      iex> delete_member(member)
      {:ok, %Member{}}

      iex> delete_member(member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_member(%Member{} = member) do
    Repo.delete(member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking member changes.

  ## Examples

      iex> change_member(member)
      %Ecto.Changeset{data: %Member{}}

  """
  def change_member(%Member{} = member, attrs \\ %{}) do
    Member.changeset(member, attrs)
  end
end
