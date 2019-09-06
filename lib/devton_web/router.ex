defmodule DevtonWeb.Router do
  use DevtonWeb, :router

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

  scope "/api", DevtonWeb do
    pipe_through :api

    get "/slack/auth", SlackAuthController, :index
  end

  scope "/", DevtonWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/privacy-policy", PageController, :privacy_policy
  end
end
