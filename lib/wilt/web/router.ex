defmodule Wilt.Web.Router do
  use Wilt.Web, :router

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

  scope "/", Wilt.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :index
    resources "/snippets", PostController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Wilt.Web do
  #   pipe_through :api
  # end
end
