defmodule ChoreDoWeb.Plugs.HouseholdPlug do
  alias ChoreDo.Households

  import Phoenix.Component

  def on_mount(
        :mount_household,
        _params,
        _session,
        %{assigns: %{current_user: current_user}} = socket
      ) do
    IO.inspect("mount_household")
    {:cont, assign(socket, :household, Households.get_household_for_user(current_user))}
  end
end
