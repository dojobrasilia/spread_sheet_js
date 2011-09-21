class window.TestHelper
  
  constructor: (@v)->

  changeValue: (row,col, val)->
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
        @cell = new CellModel({value:3})
        @cellView = new CellView(model : @cell)
        @cellView.render()

    it "render a div with content", ->
        expect($(@cellView.el)).toBe('div')
        expect($(@cellView.el)).toHaveText('3')
    
    it "renders a div with a different content", ->
        cell = new CellModel({value:5})
        cellView = new CellView(model: cell)
        cellView.render()
        expect($(cellView.el)).toBe('div')
        expect($(cellView.el)).toHaveText('5')
        
    it "updates when model changes", ->
        @cell.set value: 5
        expect($(@cellView.el)).toHaveText('5')
    
    it 'changes into a textfield when is clicked', ->
        $(@cellView.el).find("span").click()
        expect($(@cellView.el)).toContain('input[type=text]')
        
    it "when changes into a textfield it must be focused", ->
        focus= false
        @cellView.$('input').live 'focus', => focus= true
        $(@cellView.el).find("span").click()
        expect(focus).toBe true
        
    it "keeps text inside text field", ->
        $(@cellView.el).find("span").click()
        expect(@cellView.$('input[type=text]')).toHaveValue('3')
        
    it "changes input to div when blured", ->
        $(@cellView.el).find("span").click()
        $(@cellView.el).find('input[type=text]').blur()
        expect($(@cellView.el)).not.toContain('input[type=text]')
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
    v.$('table tr:eq(1) td:first span').click()
    v.$('table tr:eq(1) td:first input').val('7').blur()
    v.$('table tr:eq(1) td:eq(1) span').click()
    v.$('table tr:eq(1) td:eq(1) input').val('=A1').blur()
    expect(v.$('table tr:eq(1) td:eq(1) span')).toHaveText('7')
    
  it "changes when the referenced value changes", ->
    v = new SSView(3,3)
    v.render()
    v.$('table tr:eq(1) td:first span').click()
    v.$('table tr:eq(1) td:first input').val('7').blur()
    v.$('table tr:eq(1) td:eq(1) span').click()
    v.$('table tr:eq(1) td:eq(1) input').val('=A1').blur()

    v.$('table tr:eq(1) td:eq(1) span').click()
    expect(v.$('table tr:eq(1) td:eq(1) input')).toHaveValue('=A1')
    v.$('table tr:eq(1) td:eq(1) input').blur()
    
    v.$('table tr:eq(1) td:first span').click()
    v.$('table tr:eq(1) td:first input').val('8').blur()
    
    expect(v.$('table tr:eq(1) td:eq(1) span')).toHaveText('8')

  it "sums two cells", =>
    v = new SSView(1,3)
    v.render()
    
    helper = new TestHelper(v)
    helper.changeValue(1,0,'7')
    helper.changeValue(1,1,'8')
    helper.changeValue(1,2,'=A1+B1')

    expect(helper.getValue(1,2)).toHaveText('15')
      
