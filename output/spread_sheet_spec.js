(function() {
  describe("CellView", function() {
    it("render a div with content", function() {
      var cellView, model;
      model = new CellModel({
        value: 3
      });
      cellView = new CellView(model);
      cellView.render();
      expect(cellView.el).toBe('div');
      return expect(cellView.el).toHaveText('3');
    });
    it("renders a div with a different content", function() {
      var cellView, model;
      model = new CellModel({
        value: 5
      });
      cellView = new CellView(model);
      cellView.render();
      expect(cellView.el).toBe('div');
      return expect(cellView.el).toHaveText('5');
    });
    return it("updates when model changes", function() {
      var cellView, model;
      model = new CellModel({
        value: 5
      });
      cellView = new CellView(model);
      cellView.render();
      model.set({
        value: 3
      });
      return expect(cellView.el).toHaveText('3');
    });
  });
}).call(this);
