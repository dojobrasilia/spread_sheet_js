(function() {
  describe("CellView", function() {
    it("render a div with content", function() {
      var cell, cellView;
      cell = new CellModel({
        value: 3
      });
      cellView = new CellView({
        model: cell
      });
      cellView.render();
      expect($(cellView.el)).toBe('div');
      return expect($(cellView.el)).toHaveText('3');
    });
    it("renders a div with a different content", function() {
      var cell, cellView;
      cell = new CellModel({
        value: 5
      });
      cellView = new CellView({
        model: cell
      });
      cellView.render();
      expect($(cellView.el)).toBe('div');
      return expect($(cellView.el)).toHaveText('5');
    });
    it("updates when model changes", function() {
      var cell, cellView;
      cell = new CellModel({
        value: 5
      });
      cellView = new CellView({
        model: cell
      });
      cellView.render();
      cell.set({
        value: 3
      });
      return expect($(cellView.el)).toHaveText('3');
    });
    return it('changes into a textfield when is clicked', function() {
      var cell, cellView;
      cell = new CellModel({
        value: 5
      });
      cellView = new CellView({
        model: cell
      });
      cellView.render();
      $(cellView.el).click();
      return expect($(cellView.el)).toContain('input[type=text]');
    });
  });
}).call(this);
