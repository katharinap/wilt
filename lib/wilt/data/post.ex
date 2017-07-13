defmodule Wilt.Data.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wilt.Data.{Post, Tag, User}


  schema "posts" do
    field :body, :string
    field :title, :string
    belongs_to :user, User
    many_to_many :tags, Tag, join_through: "taggings", on_replace: :delete, on_delete: :delete_all
    
    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body, :user_id])
    |> validate_required([:title, :body])
    |> strip_unsafe_body(attrs)
    |> assoc_constraint(:user)
    |> put_assoc(:tags, parse_tags(attrs))
  end

  defp strip_unsafe_body(post, %{body: nil}) do
    post
  end

  defp strip_unsafe_body(post, %{body: body}) do
    {:safe, clean_body} = Phoenix.HTML.html_escape(body)
    post |> put_change(:body, clean_body)
  end

  defp strip_unsafe_body(post, _) do
    post
  end

  def parse_tags(attrs)  do
    (attrs["tag_list"] || attrs[:tag_list] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Wilt.Data.insert_and_get_all_tags()
  end
end
