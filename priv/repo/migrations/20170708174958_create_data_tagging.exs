defmodule Wilt.Repo.Migrations.CreateWilt.Data.Tagging do
  use Ecto.Migration

  def change do
    create table(:taggings, primary_key: false) do
      add :tag_id, references(:tags, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)
    end

    create index(:taggings, [:tag_id])
    create index(:taggings, [:post_id])
  end
end
