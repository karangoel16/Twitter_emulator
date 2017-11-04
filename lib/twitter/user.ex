defmodule Twitter.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.User


  schema "users" do
    field :email, :string
    field :encrypt_pass, :string
    field :name
    field :password, :string, virtual: true
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs\\%{}) do
    user
    |> cast(attrs, [:email, :name, :password])
    |> validate_required([:email, :name, :password])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
  end

  def reg_changeset(struct, attrs\\%{}) do
    struct
    |> changeset(attrs)
    |> cast(attrs, [:password],[])
    |> validate_length(:password, min: 5)
    |> hash_pw()
  end

  def hash_pw(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: p}} ->
        put_change(changeset, :encrypt_pass, Comeonin.Pbkdf2.hashpwsalt(p))
      _ ->
        changeset
    end
  end
  
end
