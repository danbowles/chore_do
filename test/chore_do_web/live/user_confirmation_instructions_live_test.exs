defmodule ChoreDoWeb.UserConfirmationInstructionsLiveTest do
  use ChoreDoWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import ChoreDo.UsersFixtures
  import Ecto.Query

  alias ChoreDo.Users
  alias ChoreDo.Repo

  setup do
    %{user: user_fixture()}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user_fixture())
        |> live(~p"/users/confirm")

      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, user: user} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", user: %{email: user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Users.UserToken, user_id: user.id, context: "confirm").context ==
               "confirm"
    end

    test "does not send confirmation token if user is confirmed", %{conn: conn, user: user} do
      Repo.update!(Users.User.confirm_changeset(user))

      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", user: %{email: user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Users.UserToken, user_id: user.id, context: "confirm")
    end

    test "does not send confirmation token if email is invalid", %{conn: conn, user: user} do
      {:ok, lv, _html} =
        conn
        |> log_in_user(user)
        |> live(~p"/users/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", user: %{email: "unknown@example.com"})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      # q = from u in Users.UserToken, where: context == "confirm"

      assert from(ut in Users.UserToken, where: ut.context == "confirm") |> Repo.all() == []
    end
  end
end
