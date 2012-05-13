@HardCongress = HardCongress = {}

@DEBUG = DEBUG = on

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

socket = io.connect("#{location.protocol}//#{location.host}")

HardCongress.init = ->
  hash = location.hash.substr(1)
  client = new HardCongress.Client(hash)
  
  (socket.on "new connection", (data) ->
    console.log('new connection')
    console.log(data)
  ) if DEBUG
  
  return client
