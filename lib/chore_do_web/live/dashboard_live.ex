defmodule ChoreDoWeb.DashboardLive do
  use ChoreDoWeb, :live_view

  # If a user is not a member of a household, redirect them to the household page to possibly create a new household
  def mount(_params, _session, %{assigns: %{current_user: %{member: nil}}} = socket) do
    {:ok, redirect(socket, to: "/household", status: 301)}
  end

  # If a user is an admin, redirect them to the household page
  def mount(_params, _session, %{assigns: %{current_user: %{member: member}}} = socket)
      when member.role == :admin do
    {:ok, redirect(socket, to: "/household", status: 301)}
  end

  # If a user is a member, redirect them to the chores page
  def mount(_params, _session, %{assigns: %{current_user: %{member: member}}} = socket)
      when member.role == :member do
    {:ok, redirect(socket, to: "/chores", status: 301)}
  end
end
