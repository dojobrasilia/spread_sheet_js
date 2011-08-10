
describe "@cellView", ->

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
        $(@cellView.el).click()
        $(@cellView.el).find('input[type=text]').blur()
        expect($(@cellView.el)).not.toContain('input[type=text]')
        expect($(@cellView.el)).toHaveText('3')
    
    
                
    
