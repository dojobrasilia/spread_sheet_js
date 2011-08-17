class window.CellModel extends Backbone.Model
    defaults:
        value: ''

class window.CellSumModel extends window.CellModel
    initialize: =>
        @set(value:@get('cell1').get('value')+@get('cell2').get('value'))

class window.CellSubModel extends window.CellModel
    initialize: =>
        @set(value:@get('cell1').get('value') - @get('cell2').get('value'))

class window.CellView extends Backbone.View
    className: 'cellview'
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
                row.append $("<td/>").append(cellView.el)
        $(@el).html(table)
        @
        
        
        
        