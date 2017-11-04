defmodule TwitterWeb.HashController do
    use TwitterWeb, :controller
    alias Twitter.Repo
    alias Twitter.Tweet
    alias Twitter.HashTags

    def hash_add(message,tweet_id) do
        changeset = HashTags.changeset(%HashTags{tweet_id: tweet_id}, %{hash: message})
        Repo.insert(changeset)
    end
  end
  