defmodule ChoreDoWeb.UserLoginLive do
  use ChoreDoWeb, :live_view

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      <div class="flex justify-center">
        <img src={~p"/images/chore-do.svg"} alt="ChoreDo Logo" class="h-24 w-24" />
      </div>
      <h2 class="mb-9 text-2xl font-bold text-black  sm:text-title-xl2">Sign In to Chore-Do</h2>
    </.header>

    <.simple_form for={@form} id="login_form" action={~p"/login"} phx-update="ignore">
      <.input field={@form[:email]} type="email" label="Email" required />
      <.input field={@form[:password]} type="password" label="Password" required />

      <:actions>
        <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
        <.link href={~p"/users/reset_password"} class="text-primary hover:underline">
          Forgot your password?
        </.link>
      </:actions>
      <:actions>
        <.button phx-disable-with="Signing In..." class="w-full">
          Sign In
        </.button>
      </:actions>
    </.simple_form>
    <div class="text-center mt-6">
      Don't have an account?
      <.link navigate={~p"/users/register"} class=" text-primary hover:underline">
        Sign up!
      </.link>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
