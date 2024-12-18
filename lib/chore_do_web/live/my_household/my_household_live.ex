defmodule ChoreDoWeb.MyHouseholdLive do
  use ChoreDoWeb, :live_view

  def mount(_params, _session, %{assigns: %{current_user: %{member: member}}} = socket)
      when member.role == :member do
    {:ok, redirect(socket, to: "/household", status: 301)}
  end

  def mount(_params, _session, socket), do: {:ok, socket}

  def render(assigns) do
    ~H"""
    <%= if @household do %>
      <p>You are a member of the household: <%= @household.name %></p>
    <% else %>
      <p>Get started by create a new household!</p>
    <% end %>
    """
  end
end
