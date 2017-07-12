defmodule Wilt.Web.SessionHelpers do
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Wilt.Data.get_user!(id)
  end

  def logged_in?(conn), do: !!current_user(conn)
end
