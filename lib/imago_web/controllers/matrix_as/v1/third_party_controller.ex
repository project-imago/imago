defmodule ImagoWeb.MatrixAS.V1.ThirdPartyController do
  use ImagoWeb, :controller

  def show(conn, _params) do
    send_resp(conn, 200, "")
  end
end
