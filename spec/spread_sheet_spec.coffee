
describe "spread sheet cell view", ->
    it "renders a html td", ->
        model = new CellModel({value:3})
        cellView = new CellView(model)
        expect(cellView.el).toHaveText('3')


