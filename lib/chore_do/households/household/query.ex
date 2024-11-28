defmodule ChoreDo.Households.Household.Query do
  import Ecto.Query
  alias ChoreDo.Households.Household
  alias ChoreDo.Households.Member
  defp base, do: Household

  def with_user(user) do
    from h in base(),
      join: m in Member,
      on: m.household_id == h.id,
      where: m.user_id == ^user.id,
      select: h
  end
end
