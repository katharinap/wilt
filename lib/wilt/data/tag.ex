defmodule Wilt.Data.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wilt.Data.{Tag, Post}


  schema "tags" do
    field :name, :string
    many_to_many :posts, Post, join_through: "taggings"

    timestamps()
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
