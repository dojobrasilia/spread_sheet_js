(function() {
  describe("@cellView", function() {
    beforeEach(function() {
      this.cell = new CellModel({
        value: 3
      });
      this.cellView = new CellView({
        model: this.cell
      });
      return this.cellView.render();
    });
    it("render a div with content", function() {
      expect($(this.cellView.el)).toBe('div');
      return expect($(this.cellView.el)).toHaveText('3');
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
      this.cell.set({
        value: 5
      });
      return expect($(this.cellView.el)).toHaveText('5');
    });
    it('changes into a textfield when is clicked', function() {
      $(this.cellView.el).click();
      return expect($(this.cellView.el)).toContain('input[type=text]');
    });
    it("keeps text inside text field", function() {
      $(this.cellView.el).click();
      return expect(this.cellView.$('input[type=text]')).toHaveValue('3');
    });
    return it("changes input to div when blured", function() {
      $(this.cellView.el).click();
      $(this.cellView.el).find('input[type=text]').blur();
      expect($(this.cellView.el)).not.toContain('input[type=text]');
      return expect($(this.cellView.el)).toHaveText('3');
    });
  });
}).call(this);
