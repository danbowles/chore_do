defmodule ChoreDoWeb.MyHouseholdLive do
  use ChoreDoWeb, :live_view

  def mount(_params, _session, %{assigns: %{current_user: %{member: member}}} = socket)
      when member.role == :member do
    {:ok, redirect(socket, to: "/household", status: 301)}
  end

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <h1>My Household</h1>
    <p>Welcome to your household!</p>
    """
  end
end
