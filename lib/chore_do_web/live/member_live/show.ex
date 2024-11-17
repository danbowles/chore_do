defmodule ChoreDoWeb.MemberLive.Show do
  use ChoreDoWeb, :live_view

  alias ChoreDo.Households

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:member, Households.get_member!(id))}
  end

  defp page_title(:show), do: "Show Member"
  defp page_title(:edit), do: "Edit Member"
end
