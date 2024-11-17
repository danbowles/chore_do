defmodule ChoreDo.HouseholdsTest do
  use ChoreDo.DataCase

  alias ChoreDo.Households

  describe "households" do
    alias ChoreDo.Households.Household

    import ChoreDo.HouseholdsFixtures

    @invalid_attrs %{name: nil}

    test "list_households/0 returns all households" do
      household = household_fixture()
      assert Households.list_households() == [household]
    end

    test "get_household!/1 returns the household with given id" do
      household = household_fixture()
      assert Households.get_household!(household.id) == household
    end

    test "create_household/1 with valid data creates a household" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Household{} = household} = Households.create_household(valid_attrs)
      assert household.name == "some name"
    end

    test "create_household/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Households.create_household(@invalid_attrs)
    end

    test "update_household/2 with valid data updates the household" do
      household = household_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Household{} = household} = Households.update_household(household, update_attrs)
      assert household.name == "some updated name"
    end

    test "update_household/2 with invalid data returns error changeset" do
      household = household_fixture()
      assert {:error, %Ecto.Changeset{}} = Households.update_household(household, @invalid_attrs)
      assert household == Households.get_household!(household.id)
    end

    test "delete_household/1 deletes the household" do
      household = household_fixture()
      assert {:ok, %Household{}} = Households.delete_household(household)
      assert_raise Ecto.NoResultsError, fn -> Households.get_household!(household.id) end
    end

    test "change_household/1 returns a household changeset" do
      household = household_fixture()
      assert %Ecto.Changeset{} = Households.change_household(household)
    end
  end
end
