defmodule ChoreDoWeb.UserSettingsLive do
  use ChoreDoWeb, :live_view

  alias ChoreDo.Users

  attr :title, :string, required: true

  def heading(assigns) do
    ~H"""
    <div class="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
      <h2 class="text-title-md2 font-bold text-black">
        <%= @title %>
      </h2>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :icon_name, :string
  slot :inner_block, required: true

  def settings_section(assigns) do
    ~H"""
    <div class="col-span-5 xl:col-span-3">
      <div class="rounded-sm border border-stroke bg-white shadow-default">
        <div class="border-b border-stroke px-7 py-4">
          <h3 class="font-medium text-black flex items-center gap-2">
            <%= if @icon_name do %>
              <.icon name={@icon_name} class="text-primary h-5 w-5" />
            <% end %>
            <span><%= @title %></span>
          </h3>
        </div>
        <div class="p-7">
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-270">
      <.heading title="Settings Page" />
      <div class="grid grid-cols-5 gap-8">
        <div class="col-span-5 xl:col-span-3">
          <.settings_section title="Update Your Information" icon_name="hero-user">
            <.simple_form
              for={@name_form}
              id="info_form"
              action={~p"/login?_action=info_updated"}
              method="post"
              phx-submit="update_name"
              phx-change="validate_name"
              phx-trigger-action={@trigger_submit}
            >
              <.input field={@name_form[:first_name]} label="First Name" required />
              <.input field={@name_form[:last_name]} label="Last Name" required />
              <:actions>
                <.button class="mt-3" phx-disable-with="Saving...">Update Information</.button>
              </:actions>
            </.simple_form>
          </.settings_section>
        </div>
        <div class="col-span-5 xl:col-span-3">
          <.settings_section title="Update Your Email" icon_name="hero-envelope">
            <.simple_form
              for={@email_form}
              id="email_form"
              phx-submit="update_email"
              phx-change="validate_email"
            >
              <.input field={@email_form[:email]} type="email" label="Email" required />
              <.input
                field={@email_form[:current_password]}
                name="current_password"
                id="current_password_for_email"
                type="password"
                label="Current password"
                value={@email_form_current_password}
                required
              />
              <:actions>
                <.button class="mt-3" phx-disable-with="Saving...">Update Email</.button>
              </:actions>
            </.simple_form>
          </.settings_section>
        </div>
        <div class="col-span-5 xl:col-span-3">
          <.settings_section title="Update Your Password" icon_name="hero-lock-closed">
            <.simple_form
              for={@password_form}
              id="password_form"
              action={~p"/login?_action=password_updated"}
              method="post"
              phx-change="validate_password"
              phx-submit="update_password"
              phx-trigger-action={@trigger_submit}
            >
              <input
                name={@password_form[:email].name}
                type="hidden"
                id="hidden_user_email"
                value={@current_email}
              />
              <.input field={@password_form[:password]} type="password" label="New password" required />
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label="Confirm new password"
              />
              <.input
                field={@password_form[:current_password]}
                name="current_password"
                type="password"
                label="Current password"
                id="current_password_for_password"
                value={@current_password}
                required
              />
              <:actions>
                <.button phx-disable-with="Changing...">Change Password</.button>
              </:actions>
            </.simple_form>
          </.settings_section>
        </div>
      </div>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Users.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    name_changeset = Users.change_first_name_last_name(user)
    email_changeset = Users.change_user_email(user)
    password_changeset = Users.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:name_form, to_form(name_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Users.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("validate_name", params, socket) do
    %{"user" => user_params} = params

    name_form =
      socket.assigns.current_user
      |> Users.change_first_name_last_name(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, socket |> assign(name_form: name_form)}
  end

  def handle_event("update_name", params, socket) do
    %{"user" => user_params} = params
    user = socket.assigns.current_user

    case Users.update_first_name_last_name(user, user_params) do
      {:ok, user} ->
        name_form =
          user
          |> Users.change_first_name_last_name(user_params)
          |> to_form()

        {:noreply,
         socket
         |> assign(trigger_submit: false, name_form: name_form)
         |> put_flash(:info, "Account information updated.")}

      {:error, changeset} ->
        {:noreply, assign(socket, name_form: to_form(changeset))}
    end
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Users.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Users.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Users.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Users.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Users.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
