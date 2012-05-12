@HardCongress = HardCongress = {}

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

socket = io.connect("#{location.protocol}//#{location.host}")

HardCongress.init = ->
  hash = location.hash.substr(1)
  client = new HardCongress.Client(hash)
  
  # TODO: remove this; just for testing
  socket.on "update", (data) ->
    console.log(data)
  
  return client
