class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View

    events:
        'click' : 'edit'
        'blur input' : 'blur'

    initialize: ->
        @model.bind('change', @render)
        
           
    render: =>
        $(@el).text(@model.get('value'))
        @
    
    edit: =>
        $(@el).html($("<input type='text' value=#{@model.get('value')}>"))
        
    blur: =>
        $(@el).text(@model.get('value'))
