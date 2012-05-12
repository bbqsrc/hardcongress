class HardCongress.Client
  constructor: (@sessionId) ->
    # TODO: check for valid session
  
  setName: (@name) ->
    # TODO: send name setting message
    return @name
  
  setMessage: (@message) ->
    # TODO: send message setting message
    return @message
  
  setState: (@state) ->
    # TODO: send state setting message
    return @state

  setAttention: (attention) ->
    @attention = !!attention
    # TODO: send attention setting message
    return @attention
