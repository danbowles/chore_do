defmodule ChoreDoWeb.UserRegistrationLive do
  use ChoreDoWeb, :live_view

  alias ChoreDo.Users
  alias ChoreDo.Users.User

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      <div class="flex justify-center">
        <img src={~p"/images/chore-do.svg"} alt="ChoreDo Logo" class="h-24 w-24" />
      </div>
      <h2 class="mb-9 text-2xl font-bold text-black  sm:text-title-xl2">Sign Up for Chore-Do</h2>
    </.header>

    <.simple_form
      for={@form}
      id="registration_form"
      phx-submit="save"
      phx-change="validate"
      phx-trigger-action={@trigger_submit}
      action={~p"/login?_action=registered"}
      method="post"
    >
      <.error :if={@check_errors}>
        Oops, something went wrong! Please check the errors below.
      </.error>

      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />
      <.input field={@form[:first_name]} label="First name" required />
      <.input field={@form[:last_name]} label="Last name" required />

      <:actions>
        <.button phx-disable-with="Creating account..." class="w-full">Create account</.button>
      </:actions>
    </.simple_form>
    <div class="text-center mt-6">
      Already registered?
      <.link navigate={~p"/login"} class=" text-primary hover:underline">
        Sign in!
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Users.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Users.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Users.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Users.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
