defmodule TwitterWeb.SessionController do
    use TwitterWeb, :controller

    import Twitter.Auth
    alias Twitter.Repo

    def new(conn, _params) do
        render(conn, "new.html")
    end

    def create(conn, %{"session" => %{"email" => user, "password" => password}}) do
        case login_with(conn, user, password, repo: Repo) do
            {:ok, conn} ->
                logged_user = Guardian.Plug.current_resource(conn)
                conn
                |> put_flash(:info, "logged In")
                |> redirect(to: page_path(conn, :index))
            {:error, _reason, conn}->
                conn
                |> put_flash(:error, "Wrong Username/Password")
                |> redirect(to: session_path(conn,:new))
        end
    end

    def delete(conn,_) do
        IO.puts "hello"
        conn
        |> Guardian.Plug.sign_out
        |> redirect(to: page_path(conn, :index))
    end
end