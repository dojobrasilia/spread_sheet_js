
describe "spread sheet cell view", ->
    it "renders a div with content", ->
        model = new CellModel({value:3})
        cellView = new CellView(model)
        cellView.render()
        expect(cellView.el).toBe('div')
        expect(cellView.el).toHaveText('3')
        


