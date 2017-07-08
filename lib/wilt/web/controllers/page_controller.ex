defmodule Wilt.Web.PageController do
  use Wilt.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
