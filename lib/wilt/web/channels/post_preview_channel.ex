defmodule Wilt.Web.PostPreviewChannel do
  use Phoenix.Channel

  def join("post-preview", _message, socket) do
    {:ok, socket}
  end

  def handle_in("preview_post", %{"title" => title, "body" => body}, socket) do
    post = %Wilt.Data.Post{title: title, body: body, tags: []}
    html = Phoenix.View.render_to_string(Wilt.Web.PostView, "_post.html", post: post, hide: false, show_actions: false)
 
    broadcast!(socket, "live_response", %{html: html})
    {:noreply, socket}
  end
end
