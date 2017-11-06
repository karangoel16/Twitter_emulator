defmodule TwitterWeb.RoomChannel do
    use TwitterWeb, :channel
    alias TwitterWeb.Presence
    alias Twitter.Tweet
    alias Twitter.Repo
    alias Twitter.User 
    alias Twitter.Subscriber
    alias TwitterWeb.HashController

    import Ecto.Query

    alias Phoenix.Socket.Broadcast
    def handle_info(%Broadcast{topic: _, event: ev, payload: payload}, socket) do
      push socket, ev, payload
      {:noreply, socket}
    end

    def join("room:lobby", _ , socket) do
        send self(), :after_join
        TwitterWeb.Endpoint.subscribe("room:" <> socket.assigns.user)
        #user will subscribe to its room plus the room of others 
        query = from u in User,
        where: u.name == ^socket.assigns.user,
        select: %{"id" => u."id"}
        id=Repo.one(query)["id"]
        query= from u in User,
        join: s in Subscriber,
        where: u.id == s.user_to_id and s.user_from_id == ^id,
        select: %{"name"=>u.name}
        Enum.map(Repo.all(query),fn(x)-> 
            TwitterWeb.Endpoint.subscribe("room:" <> x["name"])
        end)
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
        changeset = Tweet.changeset(%Tweet{user_id: Repo.get_by(Twitter.User, name: socket.assigns.user).id }, %{text: message })
        case Repo.insert(changeset) do
            {:ok, tweet} ->
                Enum.map(Regex.scan(~r/\B#[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, message),fn(x)->
                    HashController.hash_add((x|>List.to_tuple|>elem(0)),tweet.id)
                end)
            {:error, changeset}->
                IO.inspect changeset
        end
        TwitterWeb.Endpoint.broadcast!("room:"<>socket.assigns.user, "message:new", %{
            user: socket.assigns.user,
            body: message,
            timestamp: :os.system_time(:milli_seconds)
        })
        {:noreply,socket}
    end
end