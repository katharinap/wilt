defmodule Wilt.Web.PostViewTest do
  use Wilt.Web.ConnCase

  test "markdown/1 converts markdown to html" do
    {:safe, result} = Wilt.Web.PostView.markdown("**bold me**")
    assert String.contains? result, "<strong>bold me</strong>"
  end

  test "markdown/1 leaves text with no markdown alone" do
    {:safe, result} = Wilt.Web.PostView.markdown("leave me alone")
    assert String.contains? result, "leave me alone"
  end

  test "tag_list/1 returns a comma separated string of tags" do
    tags = [%Wilt.Data.Tag{name: "one"}, %Wilt.Data.Tag{name: "two"}]
    assert Wilt.Web.PostView.tag_list(tags) == "one,two"
  end

  test "tag_list/1 returns an empty string if the given tags are empty" do
    assert Wilt.Web.PostView.tag_list([]) == ""
  end
end
