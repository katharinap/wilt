defmodule Wilt.Web.AuthHelpers do
  use Wilt.Web, :controller

  def authenticate(conn) do
    if Wilt.Web.SessionHelpers.current_user(conn) do
      conn
    else
      conn
      |> put_flash(:info, "You must be logged in")
      |> redirect(to: "/")
      |> halt
    end
  end

  def authorize(conn, user) do
    if user == Wilt.Web.SessionHelpers.current_user(conn) do
      conn
    else
      conn
      |> put_flash(:info, "You do not have permissions to go there...")
      |> redirect(to: "/")
      |> halt
    end
  end
end
