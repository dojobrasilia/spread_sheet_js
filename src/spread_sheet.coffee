class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View

    className: 'cell'

    events:
        'click span' : 'edit'
        'blur input' : 'blur'

    initialize: ->
        @model.bind('change', @render)
        
           
    render: =>
        $(@el).html("<span>#{@model.get('value')}</span>")
        @
    
    edit: =>
        input = $("<input type='text' value=#{@model.get('value')}>")
        $(@el).html(input)
        input.focus()
        input.focus()
        
    blur: =>
        $(@el).html("<span> #{@model.get('value')} </span>")
