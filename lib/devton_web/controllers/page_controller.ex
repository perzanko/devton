defmodule DevtonWeb.PageController do
  use DevtonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
