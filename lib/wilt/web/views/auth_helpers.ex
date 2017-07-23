defmodule Wilt.Web.AuthHelpers do
  use Wilt.Web, :controller

  import Wilt.Web.SessionHelpers, only: [current_user: 1]
  
  def authenticate(conn) do
    if current_user(conn) do
      conn
    else
      conn
      |> put_flash(:info, "You must be logged in")
      |> redirect(to: "/")
      |> halt
    end
  end

  def authorize(conn, user) do
    if user.id == current_user(conn).id do
      conn
    else
      conn
      |> put_flash(:info, "You do not have permissions to go there...")
      |> redirect(to: "/")
      |> halt
    end
  end
end
