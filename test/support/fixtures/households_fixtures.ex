defmodule ChoreDo.HouseholdsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChoreDo.Households` context.
  """

  @doc """
  Generate a household.
  """
  def household_fixture(attrs \\ %{}) do
    {:ok, household} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> ChoreDo.Households.create_household()

    household
  end

  @doc """
  Generate a member.
  """
  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(%{
        role: :admin
      })
      |> ChoreDo.Households.create_member()

    member
  end
end
