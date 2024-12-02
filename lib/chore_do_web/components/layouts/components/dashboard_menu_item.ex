# credo:disable-for-this-file Credo.Check.Readability.Specs
defmodule ChoreDoWeb.Components.Layouts.DashboardMenuItem do
  @moduledoc false
  use ChoreDoWeb, :html

  import ChoreDoWeb.CoreComponents

  attr :icon_name, :string, default: nil
  attr :rest, :global, include: ~w(href method navigate)

  slot :inner_block

  def dashboard_menu_item(assigns) do
    # TODO: Active state
    ~H"""
    <li>
      <.link
        {@rest}
        class="group relative flex items-center gap-2.5 rounded-lg px-4 py-2 font-medium hover:bg-slate-900 duration-150"
      >
        <%= if @icon_name do %>
          <.icon name={@icon_name} class="h-5 w-5" />
        <% end %>
        <%= render_slot(@inner_block) %>
      </.link>
    </li>
    """
  end
end
