
describe "CellView", ->

    it "render a div with content", ->
        cell = new CellModel({value:3})
        cellView = new CellView(model : cell)
        cellView.render()
        expect($(cellView.el)).toBe('div')
        expect($(cellView.el)).toHaveText('3')
    
    it "renders a div with a different content", ->
        cell = new CellModel({value:5})
        cellView = new CellView(model: cell)
        cellView.render()
        expect($(cellView.el)).toBe('div')
        expect($(cellView.el)).toHaveText('5')
        
    it "updates when model changes", ->
        cell = new CellModel({value:5})
        cellView = new CellView(model: cell)
        cellView.render()
        cell.set value: 3
        expect($(cellView.el)).toHaveText('3')
    
    it 'changes into a textfield when is clicked', ->
        cell = new CellModel({value:5})
        cellView = new CellView(model: cell)
        cellView.render()
        $(cellView.el).click()
        expect($(cellView.el)).toContain('input[type=text]')
                
    
