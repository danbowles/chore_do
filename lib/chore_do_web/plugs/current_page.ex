defmodule ChoreDoWeb.Plugs.CurrentPage do
  import Phoenix.Component
  import Phoenix.LiveView

  @moduledoc """
  This plug is used to set the current page in the session.
  """
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont, attach_hook(socket, :current_page, :handle_params, &set_current_page/3)}
  end

  defp set_current_page(_params, _url, socket) do
    IO.inspect(Module.split(ChoreDoWeb.DashboardLive))

    current_page =
      socket.view
      |> Module.split()
      |> Enum.slice(-1..-1)
      |> maybe_remove_live()
      |> Enum.join("_")
      |> String.downcase()

    {:cont, assign(socket, current_page: current_page)}
  end

  ## When "Live" is the first item on the list, remove it.
  defp maybe_remove_live(["Live" | rest]), do: rest
  defp maybe_remove_live(list), do: list
end
