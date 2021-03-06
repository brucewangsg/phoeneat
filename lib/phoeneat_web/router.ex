defmodule PhoeneatWeb.Router do
  use PhoeneatWeb, :router

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

  scope "/", PhoeneatWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:id", LinkController, :redirection
    get "/:id/info", LinkController, :info
  end

  scope "/api/", PhoeneatWeb do
    pipe_through :api # Use the default browser stack

    post "/transform", LinkController, :submit
    post "/lookup", LinkController, :lookup
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoeneatWeb do
  #   pipe_through :api
  # end
end
