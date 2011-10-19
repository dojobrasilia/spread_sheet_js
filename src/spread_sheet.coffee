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
        a = parseInt(ma.get('value'),10)
        mb = @get('ssview').models[match[3].toUpperCase()]
        b = parseInt(mb.get('value'),10)
        
        if (ma == undefined or mb == undefined)
          @set(text: 'ERROR')        
                
        #TODO como/se testa isso?
        ma.unbind('change', @changed)
        mb.unbind('change', @changed)
        
        ma.bind('change', @changed)
        mb.bind('change', @changed)
        
        result = ''
        if match[2] == '+'
          result = a+b
        else if match[2] == '-'
          result = a-b
        else if match[2] == '/'
          result = a/b
        else
          result = a*b

        if (isNaN(result))
          @set(text: 'ERROR')
        else
          @set(text: result)
      else if(@get('value')[0]=='=')
        m= @get('ssview').models[@get('value').substring(1).toUpperCase()]
        
        if (@get('value').length == 1)
          @set(text:'=')
          return
        else if (m == undefined)
          @set(text:'ERROR')
          return        
                
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
        'keydown input' : 'keydown'
        

    initialize: ->
        @model.bind('change', @render)
        @span = $("<span/>")
        $(@el).append(@span)
        @input = $("<input type='text'>")
        @input.hide()
        $(@el).append(@input)
           
    render: =>
        @input.val(@model.get('value'))
        @span.text(@model.get('text'))
        if @mode == 'view'
          @input.hide()
          @span.show()
        else
          @span.hide()
          @input.show()
          @input.focus()
        @
    
    edit: =>
        @mode= 'edit'
        @render()
        
    blur: =>
        @model.set( value: $(@el).find('input').val() )
        @mode= 'view'
        @render()
        
    keydown: (e) =>
        @blur() if e.keyCode == 13
        
                    
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
        
        
        
        
