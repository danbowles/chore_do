defmodule ChoreDoWeb.HouseholdLive.Index do
  use ChoreDoWeb, :live_view

  alias ChoreDo.Households
  alias ChoreDo.Households.Household

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :households, Households.list_households())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Household")
    |> assign(:household, Households.get_household!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Household")
    |> assign(:household, %Household{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Households")
    |> assign(:household, nil)
  end

  @impl true
  def handle_info({ChoreDoWeb.HouseholdLive.FormComponent, {:saved, household}}, socket) do
    {:noreply, stream_insert(socket, :households, household)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    household = Households.get_household!(id)
    {:ok, _} = Households.delete_household(household)

    {:noreply, stream_delete(socket, :households, household)}
  end
end
