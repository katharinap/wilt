defmodule Wilt.Web.SessionController do
  use Wilt.Web, :controller

  import Wilt.Web.SessionHelpers, only: [login_user: 2, logout: 1]
  
  alias Wilt.Data
  
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => session_params}) do
    case Data.login_user(session_params) do
      {:ok, user} ->
	conn
	|> login_user(user)
	|> put_flash(:info, "Logged in")
	|> redirect(to: "/")
      :error ->
	conn
	|> put_flash(:info, "Wrong email or password")
	|> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> logout
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end  
end
