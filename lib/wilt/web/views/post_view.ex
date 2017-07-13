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
      post.user.email
    else
      "unknown"
    end
  end
end
