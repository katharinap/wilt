defmodule Wilt.Data.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wilt.Data.{User, Post}


  schema "users" do
    field :email, :string
    field :username, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    has_many :posts, Post
    
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :crypted_password, :password])
    |> validate_required([:email, :username, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
    |> put_change(:crypted_password, hashed_password(attrs[:password] || attrs["password"]))
  end

  defp hashed_password(nil), do: nil
  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end
end
