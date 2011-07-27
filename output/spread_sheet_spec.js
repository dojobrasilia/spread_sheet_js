(function() {
  describe("spread sheet cell view", function() {
    return it("renders a html td", function() {
      var cellView, model;
      model = new CellModel({
        value: 3
      });
      cellView = new CellView(model);
      return expect(cellView.el).toHaveText('3');
    });
  });
}).call(this);
