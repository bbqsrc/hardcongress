@HardCongress = HardCongress = {}

_.templateSettings =
  interpolate: /\{\{(.+?)\}\}/g

socket = io.connect("#{location.protocol}//#{location.host}")

HardCongress.init = ->
  hash = location.hash.substr(1)
  client = new HardCongress.Client(hash)
  return client
