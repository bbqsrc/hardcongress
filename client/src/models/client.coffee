class HardCongress.Client
  Client.attributes = ['name', 'message', 'state', 'attention']

  views: []

  constructor: (@token) ->
    socket.emit "connect", token: @token
    
    socket.on "initial state", (data) =>
      console.log("initial state")
      console.log(data)
      
      @id = data.id if data.id?
      # TODO: check for fail condition
    
    socket.on "set", (data) =>
      console.log("set")
      console.log(data)
      
      for k, v of data
        @[k] = v if k in Client.attributes
      view.render() for view in @views
  
  set: (attr, value) ->
    throw new Error("invalid attribute") unless attr in Client.attributes
    data = token: @token
    data[attr] = value
    socket.emit "set", data