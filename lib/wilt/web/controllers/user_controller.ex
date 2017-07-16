defmodule Wilt.Web.UserController do
  use Wilt.Web, :controller

  plug :authenticate when action in [:edit, :update]
  plug :authorize when action in [:edit, :update]

  alias Wilt.Data

  def new(conn, _params) do
    changeset = Data.change_user(%Wilt.Data.User{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"user" => user_params}) do
    case Data.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    user = Data.get_user!(conn.params["id"])
    changeset = Data.change_user(user)
    render(conn, "edit.html", changeset: changeset, user: user)
  end

  def update(conn, %{"user" => user_params}) do
    user = Data.get_user!(conn.params["id"])
    case Data.update_user(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  defp authenticate(conn, _) do
    Wilt.Web.AuthHelpers.authenticate(conn)
  end
  
  defp authorize(conn, _) do
    user = Data.get_user!(conn.params["id"])
    Wilt.Web.AuthHelpers.authorize(conn, user)
  end
end
