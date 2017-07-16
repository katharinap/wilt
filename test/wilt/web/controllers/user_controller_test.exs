defmodule Wilt.Web.UserControllerTest do
  use Wilt.Web.ConnCase

  @create_attrs %{email: "me@example.com", password: "supersecretpassword*42", username: "me"}
  
  test "renders form for new user", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "creates user and redirects to / when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @create_attrs
    assert redirected_to(conn) == "/"
  end

  test "does not create user and renders errors when the email is not valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{@create_attrs | email: "meatexample.com"}
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "does not create user and renders errors when the password is not valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{@create_attrs | password: "a1"}
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "does not create user and renders errors if the email has already been used", %{conn: conn} do
    insert(:user, @create_attrs)
    conn = post conn, user_path(conn, :create), user: %{@create_attrs | username: "someone"}
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "does not create user and renders errors if the username has already been used", %{conn: conn} do
    insert(:user, @create_attrs)
    conn = post conn, user_path(conn, :create), user: %{@create_attrs | email: "someone@example.com"}
    assert html_response(conn, 200) =~ "Create an account"
  end

  test "renders form for editing chosen user", %{conn: conn} do
    user = insert(:user, @create_attrs)
    conn = get with_user_session(conn, user.id), user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit User"
  end

  test "does not render form for editing chosen user if no user is logged in", %{conn: conn} do
    user = insert(:user, @create_attrs)
    conn = get conn, user_path(conn, :edit, user)
    assert redirected_to(conn) == "/"
  end

  test "does not render form for editing chosen user if it's different from the logged in user", %{conn: conn} do
    user1 = insert(:user)
    user2 = insert(:user)
    conn = get with_user_session(conn, user1.id), user_path(conn, :edit, user2)
    assert redirected_to(conn) == "/"
  end

  test "updates chosen user and redirects when data is valid", %{conn: conn} do
    user_params = params_for(:user, @create_attrs)
    user = insert(:user, user_params)
    update_params = %{@create_attrs | email: "lalala@example.com"}
    conn = put with_user_session(conn, user.id), user_path(conn, :update, user), user: update_params
    assert redirected_to(conn) == "/"

    user = Wilt.Data.get_user!(user.id)
    assert user.email == "lalala@example.com"
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user_params = params_for(:user, @create_attrs)
    user = insert(:user, user_params)
    update_params = %{@create_attrs | email: "lalalaexample.com"}
    conn = put with_user_session(conn, user.id), user_path(conn, :update, user), user: update_params
    assert html_response(conn, 200) =~ "Edit User"
  end
end
