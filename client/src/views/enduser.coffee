HardCongress.EndUserView = Backbone.View.extend
  tagName: "section"
  className: "enduser"
  
  events:
    "click #set-state": "setState"
    "keypress #state": "setState"
    "click #set-message": "setMessage"
    "keypress #message": "setMessage"
    "click #set-name": "setName"
    "keypress #name": "setName"
  
  setState: (event) ->
    return if event.type is "keypress" and event.keyCode isnt 13
    @model?.set("state", $(@el).find("#state").val().trim())
    $(@el).find("#state").val("")
    
  setMessage: (event) ->
    return if event.type is "keypress" and event.keyCode isnt 13
    @model?.set("message", $(@el).find("#message").val().trim())
    $(@el).find("#message").val("")
  
  setName: (event) ->
    return if event.type is "keypress" and event.keyCode isnt 13
    name = $(@el).find("#name").val().trim()
    return if name == ""
    @model?.set("name", name)
  
  states: [
    "Propose Motion"
    "Interject"
    "Other"
  ]
  
  template: """
  <div class='well'>
    <div class='control-group name'>
      <label class='control-label' for='name'>Name</label>
      <div class='controls'>
        <div class='input-append'>
          <input id='name' class='span3' size='16'
          type='text' placeholder='Enter a name here...'><button
          type='button' class='btn' id='set-name'>Set</button>
        </div>
      </div>
    </div>
    <div class='control-group message'>
      <label class='control-label' for='message'>Message</label>
      <div class='controls'>
        <div class='input-append'>
          <input id='message' class='span3' size='16'
          type='text' placeholder='Enter a message here...'><button
          type='button' class='btn' id='set-message'>Set</button>
        </div>
      </div>
    </div>
    <div class='control-group state'>
      <label class='control-label' for='state'>State</label>
      <div class='controls'>
        <div class='input-append'>
          <select id='state' class='span3'></select><button
          type='button' class='btn' id='set-state'>Set</button>
        </div>
      </div>
    </div>
  </div>
  """
  
  render: ->
    if $(@el).children().length == 0
      t = $(@template)
      select = t.find('select')[0]
      select.options.length = @states.length + 1
      for state, i in @states
        select.options[i+1].value = state
        select.options[i+1].text = state
      $(@el).append(t)
    
    $(@el).find(".control-group").show()
    if @model.name
      $(@el).find(".control-group.name").hide()
    else
      $(@el).find(".control-group:not(.name)").hide()
    return @
    
