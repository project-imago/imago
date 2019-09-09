defmodule ImagoWeb.MatrixAS.V1.TransactionController do
  use ImagoWeb, :controller

  def create(conn, params) do
    params |> inspect() |> Logger.debug
    send_resp(conn, 200, "")
  end
end
