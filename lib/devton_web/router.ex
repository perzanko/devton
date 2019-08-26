defmodule DevtonWeb.Router do
  use DevtonWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DevtonWeb do
    pipe_through :api

    get "/slack/auth", SlackAuthController, :index
  end
end
