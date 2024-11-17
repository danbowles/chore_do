defmodule ChoreDo.Households.Member do
  use Ecto.Schema
  import Ecto.Changeset

  schema "members" do
    field :role, Ecto.Enum, values: [:admin, :member, :viewer]
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role])
    |> validate_required([:role])
  end
end
