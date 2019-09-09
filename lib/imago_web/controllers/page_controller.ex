defmodule ImagoWeb.PageController do
  use ImagoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
