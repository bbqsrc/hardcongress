class HardCongress.Client
  views: []

  constructor: (@token) ->
    socket.emit "session", token: @token
    
    socket.on "session", (data) =>
      @id = data.id if data.id?
      # TODO: check for fail condition
    
    socket.on "set", (data) =>
      for k, v of data
        @[k] = v if k in ['name', 'message', 'state', 'attention']
      view.render() for view in @views
  
  setName: (name) ->
    socket.emit "set", token: @token, name: name
  
  setMessage: (message) ->
    socket.emit "set", token: @token, message: message
  
  setState: (state) ->
    socket.emit "set", token: @token, state: state

  setAttention: (attention) ->
    socket.emit "set", token: @token, attention: !!attention
