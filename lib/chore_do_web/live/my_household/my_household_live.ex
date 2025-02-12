defmodule ChoreDoWeb.MyHouseholdLive do
  use ChoreDoWeb, :live_view
  alias ChoreDoWeb.Components.Card

  # If a user has a non-admin role, redirect them to the chore page
  def mount(_params, _session, %{assigns: %{current_user: %{member: member}}} = socket)
      when member.role == :member do
    {:ok, redirect(socket, to: "/chores", status: 301)}
  end

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <%= if @household do %>
      <%!-- Render the dashboard --%>
      <div class="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5">
        <Card.card>
          <Card.dashboard_highlight icon_name="hero-user-group" value="5" label="Household Members" />
        </Card.card>
        <Card.card>
          <Card.dashboard_highlight icon_name="hero-rectangle-stack" value="83" label="Total Chores" />
        </Card.card>
        <Card.card>
          <Card.dashboard_highlight
            icon_name="hero-rectangle-stack"
            value="23"
            label="Unassigned Chores"
          />
        </Card.card>
        <Card.card>
          <Card.dashboard_highlight icon_name="hero-trophy" value="1,023" label="Points Earned" />
        </Card.card>
      </div>
      <div class="mt-4 grid grid-cols-12 gap-4 md:mt-6 md:gap-6 2xl:mt-7.5 2xl:gap-7.5">
        <%!-- task list --%>
        <Card.card class="col-span-12 xl:col-span-8">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-50">
                <tr>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Lorem
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Ipsum
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Dolor
                  </th>
                  <th
                    scope="col"
                    class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                  >
                    Sit
                  </th>
                </tr>
              </thead>
              <tbody class="bg-white divide-y divide-gray-200">
                <tr>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    Lorem
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Ipsum
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Dolor
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Sit
                  </td>
                </tr>
                <tr>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    Lorem
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Ipsum
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Dolor
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    Sit
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </Card.card>
        <Card.card class="col-span-12 xl:col-span-4">
          <div class="p-4">
            <h2 class="text-lg font-medium text-gray-900">Chores Completion</h2>
            <div class="mt-4">
              <div class="flex items-end space-x-2">
                <div class="w-1/4 bg-blue-500 h-24"></div>
                <div class="w-1/4 bg-blue-500 h-32"></div>
                <div class="w-1/4 bg-blue-500 h-16"></div>
                <div class="w-1/4 bg-blue-500 h-40"></div>
              </div>
              <div class="flex justify-between mt-2 text-sm text-gray-500">
                <span>Mon</span>
                <span>Tue</span>
                <span>Wed</span>
                <span>Thu</span>
              </div>
            </div>
          </div>
        </Card.card>
      </div>
    <% else %>
      <div class="h-full flex items-center justify-center">
        <Card.card with_hover={false}>
          <div class="flex flex-col items-center justify-center text-center space-y-4">
            <div class="bg-gray-200 flex h-20 w-20 items-center justify-center rounded-full">
              <.icon name="hero-plus-circle" class="h-12 w-12 text-black" />
            </div>
            <p class="text-2xl font-bold text-primary">No Household</p>
            <span class="text-lg font-medium text-black">Create a new household to get started</span>
            <.link patch={~p"/household/new"}>
              <.button>Create a Household</.button>
            </.link>
          </div>
          <%!-- <div class="w-3/5 rounded-sm border border-stroke bg-white px-7.5 py-6 shadow-default cursor-pointer hover:bg-gray-50">

          </div> --%>
          <%!-- <.link patch={~p"/household/new"}>
          <.button>Create a Household</.button>
        </.link> --%>
        </Card.card>
      </div>
    <% end %>
    <.modal
      :if={@live_action in [:new, :edit]}
      id="household-modal"
      show
      on_cancel={JS.patch(~p"/household")}
    >
      <%!-- <.live_component
        module={ChoreDoWeb.HouseholdLive.FormComponent}
        id={@household.id || :new}
        title={@page_title}
        action={@live_action}
        household={@household}
        patch={~p"/households"}
      /> --%>
      <.link patch={~p"/household"}>
        <.button type="button">Nevermind</.button>
      </.link>
    </.modal>
    """
  end
end
