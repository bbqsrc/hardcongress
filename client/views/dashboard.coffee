HardCongress.DashboardView = Backbone.View.extend
  tagName: "section"
  className: "dashboard"
  
  render: ->
  
HardCongress.DashboardClientView = Backbone.View.extend
  tagName: "article"
  className: "dashboard-client"
  
  template: """
  <div class='name'>{{ name }}</div>
  <div class='state'>{{ state }}</div>
  <div class='message'>{{ message }}</div>
  <div class='attention'></div>
  """
  
  render: ->
    node = $(_.template(@template)
      name: @model.name or "<em>unnamed</em>"
      state: @model.state or ""
      message: @model.message or ""
    )
    node.find(".attention").addClass('active') if @model.attention
    $(@el).empty().append(node);
    return @
    
