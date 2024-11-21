defmodule ChoreDoWeb.PageControllerTest do
  use ChoreDoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "ChoreDo: Helping you get things done"
  end
end
