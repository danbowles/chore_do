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

  describe "members" do
    alias ChoreDo.Households.Member

    import ChoreDo.HouseholdsFixtures

    @invalid_attrs %{role: nil}

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Households.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Households.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      valid_attrs = %{role: :admin}

      assert {:ok, %Member{} = member} = Households.create_member(valid_attrs)
      assert member.role == :admin
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Households.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      update_attrs = %{role: :member}

      assert {:ok, %Member{} = member} = Households.update_member(member, update_attrs)
      assert member.role == :member
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Households.update_member(member, @invalid_attrs)
      assert member == Households.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Households.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Households.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Households.change_member(member)
    end
  end
end
