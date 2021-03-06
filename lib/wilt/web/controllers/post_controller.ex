defmodule Wilt.Web.PostController do
  use Wilt.Web, :controller

  plug :authenticate when not action in [:index]
  plug :find_post when action in [:edit, :update, :delete]
  plug :authorize when action in [:edit, :delete, :update]

  alias Wilt.Data

  def index(conn, _params) do
    posts = Data.list_posts()
    tags = Data.list_tags()
    render(conn, "index.html", posts: posts, tags: tags)
  end

  def new(conn, _params) do
    user_id = get_session(conn, :user_id)
    changeset = Data.change_post(%Wilt.Data.Post{user_id: user_id})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Data.create_post(post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
  
  def edit(conn, _params) do
    post = conn.assigns[:post]
    changeset = Data.change_post(post)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"post" => post_params}) do
    post = conn.assigns[:post]
    case Data.update_post(post, post_params) do
      {:ok, _post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: post_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    post = conn.assigns[:post]
    {:ok, _post} = Data.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: post_path(conn, :index))
  end

  defp authenticate(conn, _) do
    Wilt.Web.AuthHelpers.authenticate(conn)
  end
  
  defp find_post(conn, _) do
    post = Data.get_post!(conn.params["id"])
    assign(conn, :post, post)
  end

  defp authorize(conn, _) do
    post = conn.assigns[:post]
    Wilt.Web.AuthHelpers.authorize(conn, post.user)
  end
end
