defmodule Wilt.Data.Factory do
  use ExMachina.Ecto, repo: Wilt.Repo

  def user_factory do
    %Wilt.Data.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      username: sequence(:username, &"user#{&1}")
    }
  end

  def tag_factory do
    %Wilt.Data.Tag{
      name: sequence(:name, &"tag#{&1}")
    }
  end

  def post_factory do
    %Wilt.Data.Post{
      title: sequence(:title, &"Super Relevant Post Number #{&1}!"),
      body: "Something interesting but complicated...",
      user: build(:user),
      tags: build_list(3, :tag, %{})
    }
  end
end
