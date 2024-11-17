defmodule ChoreDo.Repo.Migrations.CreateHouseholds do
  use Ecto.Migration

  def change do
    create table(:households) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end
