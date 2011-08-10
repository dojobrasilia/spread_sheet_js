
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
        $(@cellView.el).click()
        expect($(@cellView.el)).toContain('input[type=text]')
        
    it "keeps text inside text field", ->
        $(@cellView.el).click()
        expect($(@cellView.el).find('input[type=text]').val()).toBe('3')
    
                
    
