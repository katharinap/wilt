defmodule Wilt.DataTest do
  use Wilt.DataCase
  import Wilt.Data.Factory

  alias Wilt.Data

  describe "posts" do
    alias Wilt.Data.Post

    @valid_attrs %{body: "some body", title: "some title"}
    @update_attrs %{body: "some updated body", title: "some updated title", tag_list: "one,two"}
    @invalid_attrs %{body: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      insert(:post, Enum.into(attrs, @valid_attrs))
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
      attrs = Enum.into(%{tag_list: "tag_one, tag two,tag_three"}, @valid_attrs)
      assert {:ok, %Post{} = post} = Data.create_post(attrs)
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

      assert Enum.count(Data.list_tags) == 5
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

  describe "users" do
    alias Wilt.Data.User
    
    @valid_attrs %{email: "me@example.com", password: "supersecretpassword*42"}

    def user_fixture(attrs \\ %{}) do
      insert(:user, Enum.into(attrs, @valid_attrs))
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Data.change_user(user)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Data.create_user(@valid_attrs)
      assert user.email == "me@example.com"
      refute user.crypted_password == nil
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_user(%{email: "meatexample.com", password: "supersecretpassword*42"})
      assert {:error, %Ecto.Changeset{}} = Data.create_user(%{email: "me@example.com", password: "i*42"})
    end

    test "get_user!/1 returns the user with given id" do
      expected_user = user_fixture()
      user = Data.get_user!(expected_user.id)
      assert user.id == expected_user.id
      assert user.email == expected_user.email
      assert user.crypted_password == expected_user.crypted_password
    end

    test "get_user_for_email/1 returns the user for the given email" do
      user_fixture()
      user2 = user_fixture(%{email: "me2@example.com"})
      user = Data.get_user_for_email("me2@example.com")
      assert user.id == user2.id
      assert Data.get_user_for_email("me3@example.com") == nil
    end

    test "get_user_for_email/1 returns nil if there is no user for the given email" do
      assert Data.get_user_for_email("me2@example.com") == nil
    end

    test "login_user/1 returns {:ok, user} if the user can be authenticated" do
      Data.create_user(%{email: "me@example.com", password: "supersecretpassword*42"})
      assert {:ok, _} = Data.login_user(%{"email" => "me@example.com", "password" => "supersecretpassword*42"})
    end
    
    test "login_user/1 returns :error if the user cannot be authenticated" do
      Data.create_user(%{email: "me@example.com", password: "supersecretpassword*42"})
      assert :error = Data.login_user(%{"email" => "me@example.com", "password" => "lalalala"})
      assert :error = Data.login_user(%{"email" => "me2@example.com", "password" => "supersecretpassword*42"})
    end
  end
end
