defmodule Twitter.HashTags do
  use Ecto.Schema
  import Ecto.Changeset
  alias Twitter.HashTags
  alias Twitter.Tweet


  schema "hash" do
    field :hash, :string
    belongs_to :tweet, Tweet

    timestamps()
  end

  @doc false
  def changeset(%HashTags{} = hash_tags, attrs) do
    IO.inspect hash_tags
    hash_tags
    |> cast(attrs, [:hash])
    |> validate_required([:hash])
  end
end
