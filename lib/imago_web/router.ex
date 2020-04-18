defmodule ImagoWeb.Router do
  use ImagoWeb, :router

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

  scope "/api/v1", ImagoWeb.MatrixAS.V1 do
    pipe_through :api

    # scope "/v1", V1 do
      put "/transactions/:txn_id", TransactionController, :create

      get "/users/:user_id", UserController, :show
      get "/rooms/:room_alias", RoomController, :show

      # scope "/thirdparty", ThirdParty do
        get "/thirdparty/protocol/:protocol", ThirdPartyController, :show
        get "/thirdparty/user/:protocol", ThirdPartyController, :show
        get "/thirdparty/location/:protocol", ThirdPartyController, :show
        get "/thirdparty/location", ThirdPartyController, :show
        get "/thirdparty/user", ThirdPartyController, :show
      # end
    # end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ImagoWeb do
  #   pipe_through :api
  # end
end
