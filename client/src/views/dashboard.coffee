HardCongress.DashboardView = Backbone.View.extend
  tagName: "section"
  className: "dashboard"
  views: {}
  
  initialize: ->
    socket.on "connect", (data) =>
      for _, status of data
        console.log(status)
        @views[status.id] = new HardCongress.DashboardClientView(model: status)
      @render()
    
    socket.on "update", (data) =>
      @views[data.id].model = data
      @views[data.id].render()
      
    socket.on "new connection", (data) =>
      if @views[data.id]?
        @view[data.id].model = data
        @view[data.id].render()
      else
        @views[data.id] = new HardCongress.DashboardClientView(model: data)
        $(@el).append(@views[data.id].render().el)
    
  render: ->
    $(@el).empty()
    $(@el).append(view.render().el) for _, view of @views
    return @
  
HardCongress.DashboardClientView = Backbone.View.extend
  tagName: "article"
  className: "dashboard-client row"
  
  template: """
  <div class='name span2'>{{ name }}</div>
  <div class='state span2'>{{ state }}</div>
  <div class='message span6'>{{ message }}</div>
  <div class='attention span2'></div>
  """
  
  render: ->
    node = $(_.template(@template)
      name: @model.name or "<em>unnamed</em>"
      state: @model.state or ""
      message: @model.message or ""
    )
    node.find(".attention").addClass('active') if @model.attention
    $(@el).empty().append(node)
    return @
    
