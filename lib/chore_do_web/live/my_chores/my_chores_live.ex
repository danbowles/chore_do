defmodule ChoreDoWeb.MyChoresLive do
  use ChoreDoWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1>My Chores</h1>
    <p>Welcome to your chores!</p>
    """
  end
end
