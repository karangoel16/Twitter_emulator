#this file is made to create
defmodule TwitterWeb.SubscriberController do
    use TwitterWeb, :controller

    alias Twitter.Repo
    alias Twitter.User
    alias Twitter.Subscriber

    import Ecto.Query

    def show(conn,%{"id"=>id}) do
        subscriber = %Subscriber{user_from: Guardian.Plug.current_resource(conn), user_to: Repo.get(User,id)}
        changeset = Subscriber.changeset(subscriber, %{})
        IO.inspect subscriber
        case Repo.insert(changeset) do
            {:ok,_follower}->
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
end