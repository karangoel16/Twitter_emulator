defmodule TwitterWeb.UserController do
    use TwitterWeb, :controller

    alias Twitter.User
    alias Twitter.Subscriber
    alias Twitter.Repo

    import Ecto.Query

    def index(conn,_params) do
        users = Repo.all(User)
        IO.inspect users
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
