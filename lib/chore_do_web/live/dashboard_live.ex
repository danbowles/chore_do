defmodule ChoreDoWeb.DashboardLive do
  use ChoreDoWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>Dashboard</h1>
    <p>Welcome to ChoreDo!</p>
    """
  end
end
