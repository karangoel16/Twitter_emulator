defmodule Twitter.Repo.Migrations.CreateHash do
  use Ecto.Migration

  def change do
    create table(:hash) do
      add :hash, :string
      add :tweet_id, references(:tweets, on_delete: :nothing)

      timestamps()
    end

    create index(:hash, [:tweet_id])
  end
end
