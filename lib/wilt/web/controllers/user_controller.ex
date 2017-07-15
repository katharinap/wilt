defmodule Wilt.Web.UserController do
  use Wilt.Web, :controller

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
end
