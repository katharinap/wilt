defmodule Wilt.Web.PostView do
  use Wilt.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end

  def tag_list(tags) do
    tags
    |> Enum.map(&(&1.name))
    |> Enum.join(",")
  end

  def author_name(post) do
    if post.user do
      post.user.username || post.user.email
    else
      "unknown"
    end
  end

  def user_image(conn, post) do
    if post.user do
      gravatar_url(post.user)
    else
      static_path(conn, "/images/question_mark.png")
    end
  end
  
  def gravatar_url(user) do
    "https://www.gravatar.com/avatar/#{gravatar_hash(user)}"
  end

  def gravatar_hash(user) do
    :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)
  end

  def display_date(datetime), do: Wilt.Web.DateHelpers.format(datetime)

  def allow_edit?(conn, post) do
    post.user == Wilt.Web.SessionHelpers.current_user(conn)
  end

  def tag_classes(tags) do
    "tag-selectable #{do_tag_classes(tags)}"
  end

  defp do_tag_classes(tags) do
    tags
    |> Enum.map(&("tag-#{&1.name}"))
    |> Enum.join(" ")
  end
end
