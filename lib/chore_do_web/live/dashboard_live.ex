defmodule ChoreDoWeb.DashboardLive do
  use ChoreDoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <%!-- Render Empty State as Static --%>
    <h1>Dashboard</h1>
    <p>Welcome to ChoreDo!</p>
    <div class="mt-12 flex gap-2">
      <.button phx-click="put-success">Put Success Flash</.button>
      <.button phx-click="put-error">Put Error Flash</.button>
    </div>
    """
  end

  def handle_event("put-success", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:info, "User confirmed successfully.")}
  end

  def handle_event("put-error", _params, socket) do
    {:noreply,
     socket
     |> put_flash(:error, "User could not be confirmed.")}
  end
end
