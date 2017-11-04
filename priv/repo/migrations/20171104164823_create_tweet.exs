defmodule Twitter.Repo.Migrations.CreateTweet do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :text, :string, size: 140, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:tweets, [:user_id])

  end
end