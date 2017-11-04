defmodule Twitter.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :encrypt_pass, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
