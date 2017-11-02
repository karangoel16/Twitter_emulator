// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
//import "phoenix_html"

import {Socket, Presence} from "phoenix"

let user = document.getElementById("user").innerText
let socket = new Socket('/socket',{params: {user: user}})
socket.connect()
let presences={}

let format=(Ts) =>{
    let date =new Date(Ts)
    return date.toLocaleString()
}

let listBy =(user, {metas: metas}) => {
    return {
        user: user,
        onlineAt: format(metas[0].online_at)
    }
}

let userList = document.getElementById("userList")

let render = (presence) => {
   console.log()
    userList.innerHTML = Presence.list(presence,listBy)
    .map(presence=>`
        <li>
            ${presence.user}
        </li>
    `).join("")
}

let room= socket.channel("room:lobby")

room.on("presence_state",state=>{
    presences = Presence.syncState(presences,state)
    render(presences)
})

room.on("presence_diff",diff=>{
    presences = Presence.syncDiff(presences,diff)
    render(presences)
})

let messageInput = document.getElementById("newMessage")
messageInput.addEventListener("keypress",(e)=>{
    if(e.keyCode==13 && messageInput.value !="")
    {
        room.push("message:new",messageInput.value)
        messageInput.value=""
    }
})
let messageList = document.getElementById("messageList")
let renderMessage = (message) =>{
    message=>{
        console.log(message)
        let messageElement = document.createElement("li")
        messageElement.innerHTML=`
            <b>${message.user}</b><br>
            <i>${format(message.timestamp)}</i>
        `
        messageList.appendChild(messageElement)
        messageList.scrollTop = messageList.scrollHeight;
    }
}
room.on("message:new",message => renderMessage(message))
room.join()

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
