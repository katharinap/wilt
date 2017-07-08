defmodule Wilt.Web.PostView do
  use Wilt.Web, :view

  def markdown(body) do
    body
    |> Earmark.as_html!
    |> raw
  end
end
