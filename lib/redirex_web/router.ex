defmodule RedirexWeb.Router do
  use RedirexWeb, :router

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

  scope "/", RedirexWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/:slug", PageController, :open
  end

  # Other scopes may use custom stacks.
  scope "/api", RedirexWeb do
    pipe_through :api

    post "/create", ApiController, :create
  end
end