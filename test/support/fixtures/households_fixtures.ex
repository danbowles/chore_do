defmodule ChoreDo.HouseholdsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChoreDo.Households` context.
  """

  def unique_household_name, do: "household number #{System.unique_integer()}"

  @doc """
  Generate a household.
  """
  def household_fixture(attrs \\ %{}) do
    {:ok, household} =
      attrs
      |> Enum.into(%{
        name: unique_household_name()
      })
      |> ChoreDo.Households.create_household()

    household
  end

  @doc """
  Generate a member.
  """
  def member_fixture(user, household, attrs \\ %{}) do
    default_attrs = %{
      role: :member
    }

    attrs = Enum.into(attrs, default_attrs)

    {:ok, member} = ChoreDo.Households.add_member(user.id, household, attrs)

    member |> ChoreDo.Repo.preload([:user, :household])
  end
end
