defmodule Wilt.Web.Router do
  use Wilt.Web, :router

  import Wilt.Web.SessionHelpers, only: [assign_current_user: 2]
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Wilt.Web do
    pipe_through :browser # Use the default browser stack

    get "/", PostController, :index
    resources "/posts", PostController, except: [:show]
    resources "/users", UserController, only: [:new, :create, :edit, :update]
    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end
  
  # Other scopes may use custom stacks.
  # scope "/api", Wilt.Web do
  #   pipe_through :api
  # end
end
