defmodule Wilt.DataTest do
  use Wilt.DataCase

  alias Wilt.Data

  describe "posts" do
    alias Wilt.Data.Post

    @valid_attrs %{body: "some body", title: "some title", tag_list: "tag_one, tag two,tag_three"}
    @update_attrs %{body: "some updated body", title: "some updated title", tag_list: "one,two"}
    @invalid_attrs %{body: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Data.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Data.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Data.create_post(@valid_attrs)
      Wilt.Repo.preload(post, :tags)
      assert post.title == "some title"
      assert post.body == "some body"
      tag_names = Enum.map(post.tags, &(&1.name))
      assert tag_names == ["tag_one", "tag two", "tag_three"]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_post(@invalid_attrs)
    end

    test "create_post/1 escapes html tags in the body" do
      attrs = %{@valid_attrs | body: "Hello <iframe src='http://google.com'></iframe>"}
      assert {:ok, %Post{} = post} = Data.create_post(attrs)
      assert post.body == "Hello &lt;iframe src=&#39;http://google.com&#39;&gt;&lt;/iframe&gt;"

      attrs = %{@valid_attrs | body: "Hello <script type='javascript'>alert('foo');</script>"}
      assert {:ok, %Post{} = post} = Data.create_post(attrs)
      assert post.body == "Hello &lt;script type=&#39;javascript&#39;&gt;alert(&#39;foo&#39;);&lt;/script&gt;"
    end
    
    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Data.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.body == "some updated body"
      assert post.title == "some updated title"
      tag_names = Enum.map(post.tags, &(&1.name))
      assert tag_names == ["one", "two"]

      tags_all = Data.list_tags
      assert Enum.map(tags_all, &(&1.name)) == ["tag_one", "tag two", "tag_three", "one", "two"]
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_post(post, @invalid_attrs)
      assert post == Data.get_post!(post.id)
    end

    test "upda_post/2 escapes html tags in the body" do
      post = post_fixture()
      attrs = %{body: "Hello <iframe src='http://google.com'></iframe>"}
      assert {:ok, post} = Data.update_post(post, attrs)
      assert post.body == "Hello &lt;iframe src=&#39;http://google.com&#39;&gt;&lt;/iframe&gt;"

      post = post_fixture()
      attrs = %{body: "Hello <script type='javascript'>alert('foo');</script>"}
      assert {:ok, post} = Data.update_post(post, attrs)
      assert post.body == "Hello &lt;script type=&#39;javascript&#39;&gt;alert(&#39;foo&#39;);&lt;/script&gt;"
    end
    
    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Data.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Data.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Data.change_post(post)
    end
  end
end
