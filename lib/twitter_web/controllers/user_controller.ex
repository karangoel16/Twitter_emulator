defmodule TwitterWeb.UserController do
    use TwitterWeb, :controller

    alias Twitter.User
    alias Twitter.Subscriber
    alias Twitter.Repo

    import Ecto.Query

    def index(conn,_params) do
        query= from u in User,
        join: s in Subscriber,
        where: u.id == s.user_to_id and s.user_from_id != ^Guardian.Plug.current_resource(conn).id,
        select: %{"email" => u."email","val"=>s.user_to_id}
        subscriber1= Repo.all(query)
        IO.inspect subscriber1
        users = Repo.all(User)
        render(conn, "index.html", users: users)
    end
    
    def show(conn,%{"id" => id}) do
        user = Repo.get!(User,id)
        render(conn, "show.html", user: user)
    end

    def new(conn,_params) do
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        changeset = User.reg_changeset(%User{},user_params)
        case Repo.insert(changeset) do
            {:ok,_user} ->
                conn
                |> put_flash(:info, "User created Succesfully")
                |> redirect(to: user_path(conn, :index))
            {:error,changeset} ->
                render(conn, "new.html", changeset: changeset)
        end
    end
end
