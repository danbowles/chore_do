defmodule ChoreDoWeb.Components.Card do
  use ChoreDoWeb, :html

  attr :class, :string, default: nil
  attr :with_hover, :boolean, default: true

  slot :inner_block

  def card(assigns) do
    ~H"""
    <div class={[
      "rounded-sm border border-stroke bg-white px-7.5 py-6 shadow-default",
      @with_hover && "cursor-pointer hover:bg-gray-50",
      @class
    ]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :icon_name, :string, default: nil
  attr :value, :string, required: true
  attr :label, :string, required: true

  def dashboard_highlight(assigns) do
    ~H"""
    <div class="flex gap-2">
      <%= if @icon_name do %>
        <div class="bg-gray-200 flex h-10 w-10 items-center justify-center rounded-full">
          <.icon name={@icon_name} class="h-5 w-5" />
        </div>
      <% end %>
      <div>
        <p class="mb-1 text-4xl font-bold text-primary"><%= @value %></p>
        <span class="text-med font-medium text-black"><%= @label %></span>
      </div>
    </div>
    """
  end
end
