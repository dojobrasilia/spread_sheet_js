class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View

    constructor: (model) ->
        @model = model
        @model.bind('change', @render, @)
        $('div').live('click', @edit)
        
           
    render: =>
        @el=$("<div>#{@model.get('value')}</div>")
        @
    
    edit: =>
        console.log('chamou')
        @el=$("<div><input type='text'/></div>")
