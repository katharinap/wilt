defmodule Wilt.Web.RegistrationControllerTest do
  use Wilt.Web.ConnCase

  alias Wilt.Data

  @create_attrs %{email: "me@example.com", password: "supersecretpassword*42"}
  
  def fixture(:user) do
    {:ok, user} = Data.create_user(@create_attrs)
    user
  end

  test "renders form for new user", %{conn: conn} do
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "creates user and redirects to / when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @create_attrs
    assert redirected_to(conn) == "/"
  end

  test "does not create user and renders errors when the email is not valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{email: "meatexample.com", password: "supersecretpassword*42"}
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "does not create user and renders errors when the password is not valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{email: "someone@example.com", password: "a1*"}
    assert html_response(conn, 200) =~ "Create an account"
  end
end
