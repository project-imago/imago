defmodule ImagoWeb.MatrixAS.V1.UserController do
  use ImagoWeb, :controller

  def show(conn, _params) do
    send_resp(conn, 404, "")
  end
end
