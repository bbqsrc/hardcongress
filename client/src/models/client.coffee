class HardCongress.Client
  views: []

  constructor: (@token) ->
    socket.emit "session", token: @token
    
    socket.on "set", (data) =>
      for k, v of data
        @[k] = v if k in ['name', 'message', 'state', 'attention']
      view.render() for view in @views
    # TODO: check for valid session
  
  setName: (name) ->
    socket.emit "set", name: name
  
  setMessage: (message) ->
    socket.emit "set", message: message
  
  setState: (state) ->
    socket.emit "set", state: state

  setAttention: (attention) ->
    socket.emit "set", attention: !!attention
