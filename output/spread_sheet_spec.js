(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.TestHelper = (function() {
    function TestHelper(v) {
      this.v = v;
    }
    TestHelper.prototype.setValue = function(row, col, val) {
      this.v.$('table tr:eq(' + row + ') td:eq(' + col + ') span').click();
      return this.v.$('table tr:eq(' + row + ') td:eq(' + col + ') input').val(val).blur();
    };
    TestHelper.prototype.getValue = function(row, col) {
      return this.v.$('table tr:eq(' + row + ') td:eq(' + col + ') span');
    };
    return TestHelper;
  })();
  describe("CellModel", function() {
    return it("has default value", function() {
      var m;
      m = new CellModel;
      return expect(m.get('value')).toBe('');
    });
  });
  describe("CellView", function() {
    beforeEach(function() {
      this.cell = new CellModel({
        value: '3'
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
        value: '5'
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
        value: '5'
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
  describe("SSView", __bind(function() {
    it("renders a table with many cell views", function() {
      var v;
      v = new SSView(1, 2);
      v.render();
      expect($(v.el)).toContain('table');
      expect($(v.el).find('table tr').size()).toBe(2);
      expect($(v.el).find('table tr:eq(1) td').size()).toBe(2);
      return expect($(v.el).find('table tr:eq(1) td:first')).toContain('.cellview');
    });
    it("shows coordinates identifiers", function() {
      var v;
      v = new SSView(3, 3);
      v.render();
      expect(v.$('tr').size()).toBe(4);
      expect(v.$('th').size()).toBe(7);
      expect(v.$('table tr:first th:eq(0)')).toHaveText('');
      expect(v.$('table tr:first th:eq(1)')).toHaveText('A');
      expect(v.$('table tr:first th:eq(2)')).toHaveText('B');
      expect(v.$('table tr:first th:eq(3)')).toHaveText('C');
      expect(v.$('table tr:eq(1) th:first')).toHaveText('1');
      expect(v.$('table tr:eq(2) th:first')).toHaveText('2');
      return expect(v.$('table tr:eq(3) th:first')).toHaveText('3');
    });
    it("has reference cell", function() {
      var helper, v;
      v = new SSView(3, 3);
      v.render();
      helper = new TestHelper(v);
      helper.setValue(1, 0, '7');
      helper.setValue(1, 1, '=A1');
      return expect(helper.getValue(1, 1)).toHaveText('7');
    });
    it("changes when the referenced value changes", function() {
      var helper, v;
      v = new SSView(3, 3);
      v.render();
      helper = new TestHelper(v);
      helper.setValue(1, 0, '7');
      helper.setValue(1, 1, '=A1');
      v.$('table tr:eq(1) td:eq(1) span').click();
      expect(v.$('table tr:eq(1) td:eq(1) input')).toHaveValue('=A1');
      v.$('table tr:eq(1) td:eq(1) input').blur();
      helper.setValue(1, 0, '8');
      return expect(helper.getValue(1, 1)).toHaveText('8');
    });
    return describe("binary formulas", __bind(function() {
      beforeEach(function() {
        var v;
        v = new SSView(11, 3);
        v.render();
        return this.helper = new TestHelper(v);
      });
      it("accepts simple sum formula", function() {
        this.helper.setValue(1, 0, '7');
        this.helper.setValue(1, 1, '8');
        this.helper.setValue(1, 2, '=A1+B1');
        return expect(this.helper.getValue(1, 2)).toHaveText('15');
      });
      it("accepts simple subtraction formula", function() {
        this.helper.setValue(1, 0, '7');
        this.helper.setValue(1, 1, '8');
        this.helper.setValue(1, 2, '=A1-B1');
        return expect(this.helper.getValue(1, 2)).toHaveText('-1');
      });
      it("accepts simple multiplication formula", function() {
        this.helper.setValue(1, 0, '7');
        this.helper.setValue(1, 1, '8');
        this.helper.setValue(1, 2, '=A1*B1');
        return expect(this.helper.getValue(1, 2)).toHaveText('56');
      });
      it("accepts simple division formula", function() {
        this.helper.setValue(1, 0, '8');
        this.helper.setValue(1, 1, '2');
        this.helper.setValue(1, 2, '=A1/B1');
        return expect(this.helper.getValue(1, 2)).toHaveText('4');
      });
      it("accepts long coordinates", function() {
        this.helper.setValue(10, 0, '3');
        this.helper.setValue(10, 1, '5');
        this.helper.setValue(10, 2, '=A10+B10');
        return expect(this.helper.getValue(10, 2)).toHaveText('8');
      });
      it("ignores spaces", function() {
        this.helper.setValue(1, 0, '3');
        this.helper.setValue(1, 1, '5');
        this.helper.setValue(1, 2, '  =  A1 + B1 ');
        return expect(this.helper.getValue(1, 2)).toHaveText('8');
      });
      it("ignores cases", function() {
        this.helper.setValue(1, 0, '3');
        this.helper.setValue(1, 1, '5');
        this.helper.setValue(1, 2, '=a1+B1');
        return expect(this.helper.getValue(1, 2)).toHaveText('8');
      });
      return it("changes when references change", function() {
        this.helper.setValue(1, 0, '3');
        this.helper.setValue(1, 1, '5');
        this.helper.setValue(1, 2, '=a1+B1');
        expect(this.helper.getValue(1, 2)).toHaveText('8');
        this.helper.setValue(1, 0, '4');
        return expect(this.helper.getValue(1, 2)).toHaveText('9');
      });
    }, this));
  }, this));
}).call(this);
