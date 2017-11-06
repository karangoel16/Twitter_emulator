defmodule Twitter.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Subscriber
  alias Twitter.User

  schema "subscriber" do
    belongs_to :user_from, User
    belongs_to :user_to, User

    timestamps()
  end

  @doc false
  def changeset(%Subscriber{} = subscriber, attrs) do
    subscriber
    |> cast(attrs, [:user_from_id, :user_to_id])
    |> validate_required([])
  end
end
