defmodule Wilt.Web.SessionControllerTest do
  use Wilt.Web.ConnCase

  alias Wilt.Data

  @user_attrs %{email: "me@example.com", password: "supersecretpassword*42"}
  
  def fixture(:user) do
    # we need the crypted password for these tests and i haven't
    # figured out how to do that with ex_machina yet
    {:ok, user} = Data.create_user(@user_attrs)
    user
  end

  test "renders login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "it logs the user in if email and password are correct", %{conn: conn} do
    user = fixture(:user)
    conn = post conn, session_path(conn, :create), session: @user_attrs
    assert Plug.Conn.get_session(conn, :current_user) == user.id
    assert redirected_to(conn) == "/"
  end
  
  test "it does not log the user in if email or password are incorrect", %{conn: conn} do
    fixture(:user)
    conn = post conn, session_path(conn, :create), session: %{email: "me2@example.com", password: "supersecretpassword*42"}
    assert Plug.Conn.get_session(conn, :current_user) == nil
    assert html_response(conn, 200) =~ "Login"
    conn = post conn, session_path(conn, :create), session: %{email: "me@example.com", password: "supersecretpassword*41"}
    assert Plug.Conn.get_session(conn, :current_user) == nil
    assert html_response(conn, 200) =~ "Login"
  end

  test "it logs the user out", %{conn: conn} do
    user = fixture(:user)
    conn = post conn, session_path(conn, :create), session: @user_attrs
    assert Plug.Conn.get_session(conn, :current_user) == user.id
    conn = delete conn, session_path(conn, :delete), %{}
    assert Plug.Conn.get_session(conn, :current_user) == nil
    assert redirected_to(conn) == "/"
  end
end
