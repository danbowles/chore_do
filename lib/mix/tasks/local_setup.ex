defmodule Mix.Tasks.LocalSetup do
  @moduledoc """
  A task to setup some local data for the project.

  ## Usage
  ```
  mix local_setup --email <email>
  ```
  """
  use Mix.Task
  alias ChoreDo.Households
  alias ChoreDo.Users
  alias Ecto.Multi

  @shortdoc "Setup local data for the project"
  def run(args) do
    {options, _, _} =
      OptionParser.parse(args,
        strict: [
          email: :string
        ]
      )

    :dev = Mix.env()
    Mix.Task.run("ecto.setup")
    Mix.Task.run("app.start")

    Mix.shell().info("""
    ⚙️ Setting up local data for the project
    """)

    # Create a 'root' household
    # Create an admin user for the 'root' household
    {:ok, _} =
      Multi.new()
      |> Multi.run(:register_user, fn _repo, _args ->
        Users.register_user(%{
          email: options[:email],
          first_name: "Root",
          last_name: "Admin",
          password: "111111111111"
        })
      end)
      |> Multi.run(:confirm_user, fn _repo, _args ->
        Users.confirm_user(options[:email])
        {:ok, true}
      end)
      |> Multi.run(:add_admin_to_household, fn _repo, _args ->
        user = Users.get_user_by_email(options[:email])
        Households.create_household_with_admin(user, %{name: "Root Household"})

        Mix.shell().info("""
        🏠 Created 'Root Household'
        """)

        Mix.shell().info("""
        👩‍💼 Added '#{options[:email]}' to 'Root Household'
        """)

        {:ok, true}
      end)
      |> ChoreDo.Repo.transaction()
  end
end
