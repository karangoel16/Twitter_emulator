defmodule TwitterWeb.RoomChannel do
    use TwitterWeb, :channel
    alias TwitterWeb.Presence
    alias Twitter.Tweet
    alias Twitter.Repo
    alias Twitter.User 

    def join("room:lobby", _ , socket) do
        send self(), :after_join 
        {:ok,socket}
    end

    def handle_info(:after_join,socket) do
        Presence.track(socket, socket.assigns.user, %{
            online_at: :os.system_time(:milli_seconds)
        })
        push socket, "presence_state", Presence.list(socket)
        {:noreply,socket}
    end

    def handle_in("message:new", message, socket) do
        #Enum.map(Regex.scan(~r/\B#[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, message),fn(x)->
        #    //    
        #end)
        IO.inspect  Repo.get_by(Twitter.User, name: socket.assigns.user).id         
        changeset = Tweet.changeset(%Tweet{user_id: Repo.get_by(Twitter.User, name: socket.assigns.user).id }, %{text: message })
        case Repo.insert(changeset) do
            {:ok, _user} ->
                IO.puts "error not done"
            {:error, changeset}->
                IO.inspect changeset
        end
        broadcast! socket, "message:new", %{
            user: socket.assigns.user,
            body: message,
            timestamp: :os.system_time(:milli_seconds)
        }
        {:noreply,socket}
    end
end