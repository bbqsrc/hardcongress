app = require("http").createServer(handler)
io = require("socket.io").listen(app)
fs = require("fs")

CLIENT_FILES =
  "/": __dirname + "/app.html"
  "/client.min.js": __dirname + "/client.min.js"

app.listen "9180"

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

io.sockets.on "connection", (socket) ->
  console.log "connection get!"
