(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  describe("CellModel", function() {
    it("has default value", function() {
      var m;
      m = new CellModel;
      return expect(m.get('value')).toBe('');
    });
    return it("sums two cells", function() {
      var m1, m2, sum;
      m1 = new CellModel({
        value: 2
      });
      m2 = new CellModel({
        value: 3
      });
      sum = new CellSumModel({
        cell1: m1,
        cell2: m2
      });
      return expect(sum.get('value')).toBe(5);
    });
  });
  describe("CellView", function() {
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
      $(this.cellView.el).find("span").click();
      return expect($(this.cellView.el)).toContain('input[type=text]');
    });
    it("when changes into a textfield it must be focused", function() {
      var focus;
      focus = false;
      this.cellView.$('input').live('focus', __bind(function() {
        return focus = true;
      }, this));
      $(this.cellView.el).find("span").click();
      return expect(focus).toBe(true);
    });
    it("keeps text inside text field", function() {
      $(this.cellView.el).find("span").click();
      return expect(this.cellView.$('input[type=text]')).toHaveValue('3');
    });
    it("changes input to div when blured", function() {
      $(this.cellView.el).find("span").click();
      $(this.cellView.el).find('input[type=text]').blur();
      expect($(this.cellView.el)).not.toContain('input[type=text]');
      return expect($(this.cellView.el)).toHaveText('3');
    });
    return it("saves edited value", function() {
      $(this.cellView.el).find("span").click();
      $(this.cellView.el).find('input').val('9').blur();
      expect(this.cellView.model.get('value')).toBe('9');
      return expect($(this.cellView.el)).toHaveText('9');
    });
  });
  describe("SSView", function() {
    return it("renders a table with many cell views", function() {
      var v;
      v = new SSView(1, 2);
      v.render();
      expect($(v.el)).toContain('table');
      expect($(v.el).find('table tr').size()).toBe(1);
      expect($(v.el).find('table tr:first td').size()).toBe(2);
      return expect($(v.el).find('table tr:first td:first')).toContain('.cellview');
    });
  });
}).call(this);
