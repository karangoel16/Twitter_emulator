defmodule Twitter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.Tweet
  alias Twitter.User

  schema "tweets" do
    field :text, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%Tweet{} = text, attrs) do
    text
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text,min: 1,max: 140)
  end
end
