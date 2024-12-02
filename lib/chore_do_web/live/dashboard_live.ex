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
    """
  end
end
