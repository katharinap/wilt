defmodule Wilt.Data.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wilt.Data.Post


  schema "posts" do
    field :body, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> strip_unsafe_body(attrs)
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
end
