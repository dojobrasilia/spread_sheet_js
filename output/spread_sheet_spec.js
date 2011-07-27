(function() {
  describe("spread sheet cell view", function() {
    it("renders a div with content", function() {
      var cellView, model;
      model = new CellModel({
        value: 3
      });
      cellView = new CellView(model);
      cellView.render();
      expect(cellView.el).toBe('div');
      return expect(cellView.el).toHaveText('3');
    });
    return it("renders a div with a different content", function() {
      var cellView, model;
      model = new CellModel({
        value: 5
      });
      cellView = new CellView(model);
      cellView.render();
      expect(cellView.el).toBe('div');
      return expect(cellView.el).toHaveText('5');
    });
  });
}).call(this);
