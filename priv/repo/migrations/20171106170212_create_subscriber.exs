defmodule Twitter.Repo.Migrations.CreateSubscriber do
  use Ecto.Migration

  def change do
    create table(:subscriber) do
      add :user_from_id, references(:users, on_delete: :nothing)
      add :user_to_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
  #create unique_index(:subscriber, [:user_from_id, :user_to_id])
end
