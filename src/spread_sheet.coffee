class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View
    constructor: (model) ->
        @model = model
        @model.bind('change', @render, @)
           
    render: =>
        @el=$("<div>#{@model.get('value')}</div>")
        @
        
