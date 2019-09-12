defmodule ImagoWeb.MatrixAS.V1.TransactionController do
  use ImagoWeb, :controller

  def create(conn, _params) do
    send_resp(conn, 200, "{}")
  end
end
