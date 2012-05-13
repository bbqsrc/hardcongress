fs = require("fs")

CLIENT_FILES =
  "/": __dirname + "/app.html"
  "/client.min.js": __dirname + "/client.min.js"
  "/client.css": __dirname + "/client.css"

idCounter = 0
state =
  mode: "none"
  statuses: {}
  sessions: {}
  removes: {}

DISCONNECT_TIMEOUT = 30 * 1000

handler = (req, res) ->
  resFile = CLIENT_FILES[req.url]

  if !resFile
    res.writeHead 404
    res.end "File not found"
  else
    fs.readFile resFile, (err, data) ->
      if err
        res.writeHead 500
        res.end err.toString()
      else
        if /\.js$/.test(req.url)
          res.setHeader("Content-Type", "application/javascript")
        else if /\.css$/.test(req.url)
          res.setHeader("Content-Type", "text/css")
        res.writeHead 200
        res.end data

app = require("http").createServer(handler)
io = require("socket.io").listen(app)

app.listen "9180"

io.sockets.on "connection", (socket) ->
  handshake =
    handshake: socket.handshake
    id: socket.id
  
  socket.on "connect", (data) ->
    return unless data.token?
    
    
    unless data.token of state.statuses
      state.statuses[data.token] =
        id: idCounter++
        name: ""
        message: ""
        state: ""
        attention: no
    statuses = (status for _, status of state.statuses)
    id = state.statuses[data.token].id
    state.sessions[socket.id] = id
    
    # Stop telling the client they can remove the line, it's coming back
    clearTimeout(state.removes[id])
    delete state.removes[id]
    
    socket.emit "connect", statuses
    socket.emit "set", state.statuses[data.token]
    socket.broadcast.emit "new connection", state.statuses[data.token]

  socket.on "set", (data) ->
    return unless data.token?
    t = data.token
    for k, v of data
      state.statuses[t][k] = v if k in ["name", "message", "state", "attention"]
    
    socket.emit "set", state.statuses[data.token]
    socket.emit "update", state.statuses[data.token]
    socket.broadcast.emit "update", state.statuses[data.token]
  
  socket.on "disconnect", (data) ->
    id = state.sessions[socket.id]
    socket.broadcast.emit "disconnect", id: id
    
    # Tell the client they can remove the view entirely after timeout
    state.removes[id] = setTimeout(() ->
      socket.broadcast.emit "remove", id: state.sessions[socket.id]
      delete state.sessions[socket.id]
    , DISCONNECT_TIMEOUT)

