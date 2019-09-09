defmodule ImagoWeb.MatrixAS.V1.RoomController do
  use ImagoWeb, :controller

  def show(conn, params) do
    params |> inspect() |> Logger.debug
    send_resp(conn, 404, "")
  end
end
