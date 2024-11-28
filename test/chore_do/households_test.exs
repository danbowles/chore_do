defmodule ChoreDo.HouseholdsTest do
  use ChoreDo.DataCase

  alias ChoreDo.Households
  import ChoreDo.UsersFixtures

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

    test "get_household_for_user/1 returns the household for the given user" do
      user = user_fixture()
      user_two = user_fixture()
      household_one = household_fixture()
      _member = member_fixture(user, household_one)

      assert Households.get_household_for_user(user) == household_one
      assert Households.get_household_for_user(user_two) == nil
    end

    test "create_household/1 with valid data creates a household" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Household{} = household} = Households.create_household(valid_attrs)
      assert household.name == "some name"
    end

    test "create_household/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Households.create_household(@invalid_attrs)
    end

    test "create_household_with_admin/2 should create a household with an admin" do
      user = user_fixture()
      valid_attrs = %{name: "some name"}

      assert {:ok, %Household{} = household} =
               Households.create_household_with_admin(user, valid_attrs)

      household = household |> ChoreDo.Repo.preload(:members)

      assert household.name == "some name"
      assert household.members |> Enum.map(& &1.role) == [:admin]
      assert household.members |> Enum.map(& &1.user_id) == [user.id]
    end

    test "create_household_with_admin/2 user cannot create a household if they are already a member of a household" do
      user = user_fixture()
      valid_attrs = %{name: "some name"}

      {:ok, %Household{}} =
        Households.create_household_with_admin(user, valid_attrs)

      assert {:error, :already_member} = Households.create_household_with_admin(user, valid_attrs)

      # household = household |> ChoreDo.Repo.preload(:members)

      # assert household.name == "some name"
      # assert household.members |> Enum.map(& &1.role) == [:admin]
      # assert household.members |> Enum.map(& &1.user_id) == [user.id]
    end

    test "update_household/2 with valid data updates the household" do
      household = household_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Household{} = household} =
               Households.update_household(household, update_attrs)

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
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)
      assert Households.list_members() |> Enum.map(& &1.id) == [member.id]
    end

    test "get_member!/1 returns the member with given id" do
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)

      assert Households.get_member!(member.id) |> ChoreDo.Repo.preload([:user, :household]) ==
               member
    end

    test "add_member/3 with valid data creates a member" do
      valid_attrs = %{role: :admin}
      user = user_fixture()
      household = household_fixture()

      assert {:ok, %Member{} = member} = Households.add_member(user.id, household, valid_attrs)
      assert member.role == :admin
    end

    # TODO: Unsure how to handle newly-created households right now.
    test "add_member/3 when household has no admins fails" do
    end

    test "add_member/3 when that user already has a member fails" do
      user = user_fixture()
      household_1 = household_fixture()
      household_2 = household_fixture()

      assert {:ok, %Member{}} = Households.add_member(user.id, household_1, %{role: :admin})

      assert {:error, :already_member} =
               Households.add_member(user.id, household_2, %{role: :admin})
    end

    test "update_member/2 with valid data updates the member" do
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)
      update_attrs = %{role: :member}

      assert {:ok, %Member{} = member} = Households.update_member(member, update_attrs)
      assert member.role == :member
    end

    test "update_member/2 with invalid data returns error changeset" do
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)
      assert {:error, %Ecto.Changeset{}} = Households.update_member(member, @invalid_attrs)

      assert member ==
               Households.get_member!(member.id) |> ChoreDo.Repo.preload([:user, :household])
    end

    test "delete_member/1 deletes the member" do
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)
      assert {:ok, %Member{}} = Households.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Households.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      user = user_fixture()
      household = household_fixture()
      member = member_fixture(user, household)
      assert %Ecto.Changeset{} = Households.change_member(member)
    end
  end
end
