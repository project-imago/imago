defmodule ImagoWeb.Router do
  use ImagoWeb, :router

  require MatrixAppService.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ImagoWeb do
    pipe_through :api

    get "/obj/search", GroupController, :search
  end

  MatrixAppService.Phoenix.Router.routes()

  # Other scopes may use custom stacks.
  # scope "/api", ImagoWeb do
  #   pipe_through :api
  # end
end
