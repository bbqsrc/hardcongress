HardCongress.DashboardView = Backbone.View.extend
  tagName: "section"
  className: "dashboard"
  views: {}
  
  initialize: ->
    socket.on "connect", (data) =>
      for _, status of data
        @views[status.id] = new HardCongress.DashboardClientView(model: status)
      @render()
    
    socket.on "update", (data) =>
      @views[data.id].model = data
      @views[data.id].render()
      
    socket.on "new connection", (data) =>
      if @views[data.id]?
        @views[data.id].model = data
        @views[data.id].render()
      else
        @views[data.id] = new HardCongress.DashboardClientView(model: data)
        $(@el).append(@views[data.id].render().el)
    
    return
    
  render: ->
    $(@el).empty()
    $(@el).append(view.render().el) for _, view of @views
    return @
  
HardCongress.DashboardClientView = Backbone.View.extend
  tagName: "div"
  className: "client row"
  
  template: """
  <div class='name span2'>{{ name }}</div>
  <div class='state span4'>{{ state }}</div>
  <div class='message span6'>{{ message }}</div>
  """
  
  render: ->
    node = $(_.template(@template)
      name: @model.name or "<em>unnamed</em>"
      state: @model.state or ""
      message: @model.message or ""
    )
    $(@el).addClass('attention') if @model.attention
    $(@el).empty().append(node)
    return @
    
