defmodule PhoeneatWeb.PageController do
  use PhoeneatWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
