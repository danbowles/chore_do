defmodule ChoreDo.Households.Household do
  use Ecto.Schema
  import Ecto.Changeset

  schema "households" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(household, attrs) do
    household
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
