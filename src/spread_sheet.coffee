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
        @model.set( value: $(@el).find('input').val() )
        @mode= 'view'
        @render()

class window.SSView extends Backbone.View
    
    initialize: (rows, cols)=>
        @rows = rows
        @cols = cols
    
    render: =>
        table = $("<table/>")
        for i in [1..@rows]
            row = $("<tr/>")
            table.append(row)
            for j in [1..@cols]
                cellView = new CellView(model : new CellModel)
                cellView.render()
                col = $("<td/>")
                col.append(cellView.el)
                row.append(col)
        $(@el).html(table)
        
        
        
        
        