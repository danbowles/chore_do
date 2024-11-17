defmodule ChoreDo.Repo.Migrations.CreateMembers do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :role, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :household_id, references(:households, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:members, [:user_id, :household_id],
             name: :members_user_id_household_id_index
           )
  end
end
