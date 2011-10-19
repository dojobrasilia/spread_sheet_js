class window.TestHelper
  
  constructor: (@v)->

  setValue: (row,col, val)->
    @v.$('table tr:eq('+row+') td:eq('+col+') span').click()
    @v.$('table tr:eq('+row+') td:eq('+col+') input').val(val).blur()

  getValue: (row, col)->
    return @v.$('table tr:eq('+row+') td:eq('+col+') span')

describe "CellModel", ->
    it "has default value", ->
        m= new CellModel
        expect(m.get('value')).toBe ''
    
    
    # deve unbind'ar as celulas referenciadas qndo deixa de ser fórmula
    #it "listens to changes in the referenced cell", ->
    #  v = new SSView(1,2)
    #  v.render()
    #  source = v.models['A1']
    #  dest = v.models['B1']
    #  
    #  dest.set(value:'=A1')
    #  
    #  changed = false
    #  dest.changed = ()=>
    #    changed = true
    #    console.log 'oi'
    #    
    #  source.set(value:'8')
    #  expect(changed).toBe true
    
    # Paramos aqui     
    # it "multiplies two non-abscells", ->
    #        m1 = new CellModel(value:10)
    #        m2 = new CellModel(value:2)
    #        sum = new CellMultModel(cell1:m1, cell2:m2)
    #        expect(sum.get('value')).toBe(20)

describe "CellView", ->

	beforeEach ->
        @cell = new CellModel({value:'3'})
        @cellView = new CellView(model : @cell)
        @cellView.render()

    it "render a div with content", ->
        expect($(@cellView.el)).toBe('div')
        expect($(@cellView.el)).toHaveText('3')
    
    it "renders a div with a different content", ->
        cell = new CellModel({value:'5'})
        cellView = new CellView(model: cell)
        cellView.render()
        expect($(cellView.el)).toBe('div')
        expect($(cellView.el)).toHaveText('5')
        
    it "updates when model changes", ->
        @cell.set value: '5'
        expect($(@cellView.el)).toHaveText('5')
    
    it 'hides span when clicked', ->
        $(@cellView.el).find("span").click()
        expect(@cellView.$('span').css('display')).toBe('none')
        expect(@cellView.$('input').css('display')).toBe('')
        
    it "when changes into a textfield it must be focused", ->
        focus= false
        @cellView.$('input').live 'focus', => focus= true
        $(@cellView.el).find("span").click()
        expect(focus).toBe true
        
    it "keeps text inside text field", ->
        $(@cellView.el).find("span").click()
        expect(@cellView.$('input')).toHaveValue('3')
        
    it "hides input when blured", ->
        $(@cellView.el).find("span").click()
        $(@cellView.el).find('input').blur()
        expect(@cellView.$('input').css('display')).toBe('none')
        expect(@cellView.$('span').css('display')).toBe('')
        expect($(@cellView.el)).toHaveText('3')
    
    it "saves edited value", ->
        $(@cellView.el).find("span").click()
        $(@cellView.el).find('input').val('9').blur()
        expect(@cellView.model.get('value')).toBe('9')
        expect($(@cellView.el)).toHaveText('9')  

describe "SSView", =>

  it "renders a table with many cell views", ->
      v = new SSView(1,2)
      v.render()
      expect($(v.el)).toContain('table')
      expect($(v.el).find('table tr').size()).toBe(2)
      expect($(v.el).find('table tr:eq(1) td').size()).toBe(2)
      expect($(v.el).find('table tr:eq(1) td:first')).toContain('.cellview')
      
  it "shows coordinates identifiers", ->
    v = new SSView(3,3)
    v.render()
    expect(v.$('tr').size()).toBe(4)
    expect(v.$('th').size()).toBe(7)
    expect(v.$('table tr:first th:eq(0)')).toHaveText('')
    expect(v.$('table tr:first th:eq(1)')).toHaveText('A')
    expect(v.$('table tr:first th:eq(2)')).toHaveText('B')
    expect(v.$('table tr:first th:eq(3)')).toHaveText('C')      
    
    expect(v.$('table tr:eq(1) th:first')).toHaveText('1')
    expect(v.$('table tr:eq(2) th:first')).toHaveText('2')
    expect(v.$('table tr:eq(3) th:first')).toHaveText('3')
  
  it "has reference cell", ->
    v = new SSView(3,3)
    v.render()
    
    helper = new TestHelper(v)
    
    helper.setValue(1,0,'7')
    helper.setValue(1,1,'=A1')
    
    expect(helper.getValue(1,1)).toHaveText('7')
    
  it "changes when the referenced value changes", ->
    v = new SSView(3,3)
    v.render()
    
    helper = new TestHelper(v)
    
    helper.setValue(1,0,'7')
    helper.setValue(1,1,'=A1')
    
    v.$('table tr:eq(1) td:eq(1) span').click()
    expect(v.$('table tr:eq(1) td:eq(1) input')).toHaveValue('=A1')
    v.$('table tr:eq(1) td:eq(1) input').blur()
    
    helper.setValue(1,0,'8')
    
    expect(helper.getValue(1,1)).toHaveText('8')

  describe "binary formulas", =>
    
    beforeEach ->
      @v = new SSView(11,3)
      @v.render()
      @helper = new TestHelper(@v)
    
    it "accepts simple sum formula", ->
      @helper.setValue(1,0,'7')
      @helper.setValue(1,1,'8')
      @helper.setValue(1,2,'=A1+B1')
      expect(@helper.getValue(1,2)).toHaveText('15')

    it "accepts simple subtraction formula", ->
      @helper.setValue(1,0,'7')
      @helper.setValue(1,1,'8')
      @helper.setValue(1,2,'=A1-B1')
      expect(@helper.getValue(1,2)).toHaveText('-1')

    it "accepts simple multiplication formula", ->
      @helper.setValue(1,0,'7')
      @helper.setValue(1,1,'8')
      @helper.setValue(1,2,'=A1*B1')
      expect(@helper.getValue(1,2)).toHaveText('56')

    it "accepts simple division formula", ->
      @helper.setValue(1,0,'8')
      @helper.setValue(1,1,'2')
      @helper.setValue(1,2,'=A1/B1')
      expect(@helper.getValue(1,2)).toHaveText('4')

    it "accepts long coordinates", ->
      @helper.setValue 10,0,'3'
      @helper.setValue 10,1,'5'
      @helper.setValue 10,2,'=A10+B10'
      expect(@helper.getValue 10,2).toHaveText '8'
    
    it "ignores spaces", ->
      @helper.setValue 1,0,'3'
      @helper.setValue 1,1,'5'
      @helper.setValue 1,2,'  =  A1 + B1 '
      expect(@helper.getValue 1,2).toHaveText '8'
    
    it "ignores cases", ->
      @helper.setValue 1,0,'3'
      @helper.setValue 1,1,'5'
      @helper.setValue 1,2,'=a1+B1'
      expect(@helper.getValue 1,2).toHaveText '8'
    
    it "changes when references change", ->
      @helper.setValue 1,0,'3'
      @helper.setValue 1,1,'5'
      @helper.setValue 1,2,'=a1+B1'
      expect(@helper.getValue 1,2).toHaveText '8'
      @helper.setValue 1,0,'4'
      expect(@helper.getValue 1,2).toHaveText '9'
    
    it "blurs when enter is pressed", ->
      @v.$('table tr:eq(1) td:eq(1) span').click()
      e = jQuery.Event("keydown")
      e.keyCode = 13
      @v.$('table tr:eq(1) td:eq(1) input').val('2').trigger(e)
      expect(@helper.getValue 1,1).toHaveText '2' 

    it "always consider numbers as decimal", ->
      @helper.setValue 1,0,'010'
      @helper.setValue 1,1,'050'
      @helper.setValue 1,2,'=a1+B1'
      expect(@helper.getValue 1,2).toHaveText '60'
    
    it "shows error message for mixing numbers and text in a formula", ->
      @helper.setValue 1,0,'3'
      @helper.setValue 1,1,'ABACATE'
      @helper.setValue 1,2,'=a1+B1'
      expect(@helper.getValue 1,2).toHaveText 'ERROR'
      
    #TODO: Formula de formulas
    #TODO: Completar fórmula clicando
    #TODO: Dá pala quando a gente altera uma célula referenciada por fórmulas pra string
    #TODO: só igual da pau
    #TODO: ignore case na formula de igualdade
    #TODO: verificar se está acumulando eventos
    #TODO: resolver testes que funcionam só no chrome
  
    
