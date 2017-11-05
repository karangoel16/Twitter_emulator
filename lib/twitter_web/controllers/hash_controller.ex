defmodule TwitterWeb.HashController do
    use TwitterWeb, :controller
    alias Twitter.Repo
    alias Twitter.Tweet
    alias Twitter.User
    alias Twitter.HashTags
    import Ecto.Query

    def index(conn, _params) do
        query= from c in Tweet,
            join: h in HashTags,
            join: u in User, 
            distinct: h.tweet_id,
            where: c.id == h.tweet_id and c.user_id == u.id,
            select: %{"text" => c."text","name"=>u."name"}
        hashs= Repo.all(query)
        render(conn, "index.html",hashs: hashs)
    end

    def hash_add(message,tweet_id) do
        changeset = HashTags.changeset(%HashTags{tweet_id: tweet_id}, %{hash: message})
        Repo.insert(changeset)
    end


end
  