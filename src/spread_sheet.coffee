class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View
    constructor: (model) ->
        @value = model.get('value')
           
    render: ->
        @el=$("<div>#{@value}</div>")
        
