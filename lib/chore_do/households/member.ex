defmodule ChoreDo.Households.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :role, Ecto.Enum, values: [:owner, :admin, :member, :viewer]
    belongs_to :user, ChoreDo.Users.User
    belongs_to :household, ChoreDo.Households.Household
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role])
    |> validate_required([:role, :household_id, :user_id])
    |> unique_constraint(:user_id, name: :members_user_id_household_id_index)
  end
end
