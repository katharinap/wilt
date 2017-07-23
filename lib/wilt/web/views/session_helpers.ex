defmodule Wilt.Web.SessionHelpers do
  def login_user(conn, user) do
    conn
    |> Plug.Conn.put_session(:user_id, user.id)
    |> Plug.Conn.assign(:current_user, user)
  end

  def logout(conn) do
    conn
    |> Plug.Conn.delete_session(:user_id)
    |> Plug.Conn.assign(:current_user, nil)
  end

  def current_user(conn) do
    conn.assigns[:current_user] || load_current_user(conn)
  end

  defp load_current_user(conn) do
    id = Plug.Conn.get_session(conn, :user_id)
    if id do
      user = Wilt.Data.get_user!(id)
      login_user(conn, user)
      user
    end
  end
  
  def logged_in?(conn), do: !!current_user(conn)
end
