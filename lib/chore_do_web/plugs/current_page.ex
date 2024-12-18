defmodule ChoreDoWeb.Plugs.CurrentPage do
  import Phoenix.Component
  import Phoenix.LiveView

  @moduledoc """
  This plug is used to set the current page in the session.
  """

  def on_mount(:default, _params, _session, socket) do
    {:cont, attach_hook(socket, :current_page, :handle_params, &set_current_page/3)}
  end

  defp set_current_page(_params, _url, socket) do
    current_page =
      case socket.view do
        ChoreDoWeb.MyHouseholdLive ->
          :household

        ChoreDoWeb.MyChoresLive ->
          :chores

        ChoreDoWeb.UserSettingsLive ->
          :user_settings

        _ ->
          nil
      end

    {:cont, assign(socket, current_page: current_page)}
  end
end
