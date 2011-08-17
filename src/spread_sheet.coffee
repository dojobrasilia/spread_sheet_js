class window.CellModel extends Backbone.Model


class window.CellView extends Backbone.View
    className: 'cell'
    mode: 'view'
    events:
        'click span' : 'edit'
        'blur input' : 'blur'

    initialize: ->
        @model.bind('change', @render)
           
    render: =>
        if @mode == 'view'
          $(@el).html("<span>#{@model.get('value')}</span>")
        else
          input = $("<input type='text' value=#{@model.get('value')}>")
          $(@el).html(input)
          input.focus()
        @
    
    edit: =>
        @mode= 'edit'
        @render()
        
    blur: =>
        @mode= 'view'
        @render()
