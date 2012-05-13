class HardCongress.Client
  Client.attributes = ['name', 'message', 'state', 'attention']

  views: []

  constructor: (@token) ->
    socket.emit "connect", token: @token
    socket.on "set", (data) =>
      (console.log("set")
      console.log(data)) if DEBUG
      @setAll data
  
  setAll: (data) ->
    for k, v of data
      @[k] = v if k in Client.attributes
    view.render() for view in @views
    return
  
  set: (attr, value) ->
    throw new Error("invalid attribute") unless attr in Client.attributes
    data = token: @token
    data[attr] = value
    socket.emit "set", data
    return
