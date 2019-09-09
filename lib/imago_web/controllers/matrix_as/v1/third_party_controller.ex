defmodule ImagoWeb.MatrixAS.V1.ThirdPartyController do
  use ImagoWeb, :controller

  def show(conn, params) do
    params |> inspect() |> Logger.debug
    send_resp(conn, 200, "")
  end
end
