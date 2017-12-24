defmodule PhoeneatWeb.LinkControllerTest do
  use PhoeneatWeb.ConnCase

  test "GET /transform", %{conn: conn} do
    conn = get conn, "/transform"
    assert html_response(conn, 200) =~ "error"
  end
end
