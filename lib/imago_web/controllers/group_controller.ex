defmodule ImagoWeb.GroupController do
  use ImagoWeb, :controller
  require Logger

  def search(conn, %{"property" => property, "term" => term, "lc" => lc}) do
    case Imago.Group.search(property, term, lc) do
      {:ok, results} ->
        json(conn, %{term: term, results: results})
      {:error, error} ->
        json(conn, %{error: error})
    end
  end
end
