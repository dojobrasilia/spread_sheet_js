class window.CellModel extends Backbone.Model
    formula: ///
      \s* \= \s*   # =
      (\w \d+) \s* # coordinate (ex: A1)
      ([*+-/]) \s*       # +
      (\w \d+) \s* # coordinate (ex: A1)
      ///
  
    defaults:
        value: ''
        text: ''
    
    initialize: ->
      @bind('change', @changed)
      @changed()
    
    changed: =>
      if match= @get('value').match(@formula)
        ma = @get('ssview').models[match[1].toUpperCase()]
        a = parseInt(ma.get('value'))
        mb = @get('ssview').models[match[3].toUpperCase()]
        b = parseInt(mb.get('value'))
        
        #TODO como/se testa isso?
        ma.unbind('change', @changed)
        mb.unbind('change', @changed)
        
        ma.bind('change', @changed)
        mb.bind('change', @changed)
        
        if match[2] == '+'
          @set(text: a+b)
        else if match[2] == '-'
          @set(text: a-b)
        else if match[2] == '/'
          @set(text: a/b)
        else
          @set(text: a*b)
        
      else if(@get('value')[0]=='=')
        m= @get('ssview').models[@get('value').substring(1)]
        
        #TODO como/se testa isso?
        m.unbind('change', @changed)
        
        m.bind('change', @changed)

        @set(text: m.get('text'))
      else
        @set(text:@get('value'))
        
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
          $(@el).html("<span>#{@model.get('text')}</span>")
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
    models: {}
    initialize: (rows, cols)=>
        @rows = rows
        @cols = cols
    
    render: =>
        table = $("<table/>")
        letters = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 
        'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 
        'V', 'W', 'X', 'Y', 'Z']
        for rowIndex in [0..@rows]
            row = $("<tr/>")
            table.append(row)
            for colIndex in [0..@cols]
                if rowIndex == 0
                  row.append $('<th/>').text(letters[colIndex])
                else if colIndex == 0
                  row.append $('<th>').text(rowIndex)
                else
                  @models["#{letters[colIndex]}#{rowIndex}"]=new CellModel({ssview: @})
                  cellView = new CellView(model: @models["#{letters[colIndex]}#{rowIndex}"])
                  cellView.render()
                  row.append $("<td/>").append(cellView.el)
        $(@el).html(table)
        @
        
        
        
        