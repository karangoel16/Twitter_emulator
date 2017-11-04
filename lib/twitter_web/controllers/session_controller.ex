defmodule TwitterWeb.SessionController do
    use TwitterWeb, :controller

    alias Twitter.Repo

    def new(conn, _params) do
        render(conn, "new.html")
    end

    def create(conn, %{"session" => %{"email" => user, "password" => password}}) do
        case Twitter.Auth.login_with(conn, user, password, repo: Repo) do
            {:ok, conn} ->
                logged_user = Guardian.Plug.current_resource(conn)
                conn
                |> put_flash(:info, "User created Succesfully")
                |> redirect(to: page_path(conn, :index))
            {:error, _reason, conn}->
                conn
                |> put_flash(:info, "User created Succesfully")
                |> redirect("new.html")
        end
    end

    def delete(conn, _) do
        conn
        |> Guardian.Plug.sign_out
        |> redirect(to: '/')
    end
end