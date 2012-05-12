fs = require("fs")

CLIENT_FILES =
  "/": __dirname + "/app.html"
  "/client.min.js": __dirname + "/client.min.js"

idCounter = 0

state =
  mode: "none"
  statuses: {}
  
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
        res.writeHead 200
        res.end data

app = require("http").createServer(handler)
io = require("socket.io").listen(app)

app.listen "9180"

io.sockets.on "connection", (socket) ->
  socket.on "session", (data) ->
    # TODO: handle data.token being absent
    unless data.token of state.statuses
      state.statuses[data.token] =
        id: idCounter++
        name: ""
        message: ""
        state: ""
        attention: no
    statuses = (status for _, status of state.statuses)
    socket.emit "session", statuses
    socket.broadcast.emit "new connection", state.statuses[data.token]

  socket.on "set", (data) ->
    return unless data.token?
    t = data.token
    for k, v of data
      state.statuses[t][k] = v if k in ["name", "message", "state", "attention"]
    socket.emit "set", data
    socket.broadcast.emit "update", state.statuses[data.token]
