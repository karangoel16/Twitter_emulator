#this file is made to create
defmodule TwitterWeb.SubscriberController do
    use TwitterWeb, :controller

    alias Twitter.Repo
    alias Twitter.User
    alias Twitter.Subscriber

    import Ecto.Query

    def new(conn,%{"id"=>id}) do
        subscriber = %Subscriber{user_from: Guardian.Plug.current_resource(conn), user_to: Repo.get(User,id)}
        changeset = Subscriber.changeset(subscriber, %{})
        case Repo.insert(changeset) do
            {:ok,_subscriber}->
                conn
                |> put_flash(:info, "Subscribed Succesfully")
                |> redirect(to: user_path(conn, :index))
            {:error,changeset}->
                IO.inspect changeset
                conn
                |> put_flash(:error, "Some error occurred")
                |> redirect(to: user_path(conn, :index))
        end
    end
    
    def show(conn,_params) do
        query= from u in User,
        join: s in Subscriber,
        where: u.id == s.user_to_id and s.user_from_id == ^Guardian.Plug.current_resource(conn).id,
        select: %{"email" => u."email","name"=>u.name}
        subscriber= Repo.all(query)
        render(conn,"index.html", subscriber: subscriber)
    end
end