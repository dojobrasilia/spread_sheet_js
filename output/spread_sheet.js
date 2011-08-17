(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  }, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.CellModel = (function() {
    __extends(CellModel, Backbone.Model);
    function CellModel() {
      CellModel.__super__.constructor.apply(this, arguments);
    }
    return CellModel;
  })();
  window.CellView = (function() {
    __extends(CellView, Backbone.View);
    function CellView() {
      this.blur = __bind(this.blur, this);
      this.edit = __bind(this.edit, this);
      this.render = __bind(this.render, this);
      CellView.__super__.constructor.apply(this, arguments);
    }
    CellView.prototype.className = 'cellview';
    CellView.prototype.mode = 'view';
    CellView.prototype.events = {
      'click span': 'edit',
      'blur input': 'blur'
    };
    CellView.prototype.initialize = function() {
      return this.model.bind('change', this.render);
    };
    CellView.prototype.render = function() {
      var input;
      if (this.mode === 'view') {
        $(this.el).html("<span>" + (this.model.get('value')) + "</span>");
      } else {
        input = $("<input type='text' value=" + (this.model.get('value')) + ">");
        $(this.el).html(input);
        input.focus();
      }
      return this;
    };
    CellView.prototype.edit = function() {
      this.mode = 'edit';
      return this.render();
    };
    CellView.prototype.blur = function() {
      this.model.set({
        value: $(this.el).find('input').val()
      });
      this.mode = 'view';
      return this.render();
    };
    return CellView;
  })();
  window.SSView = (function() {
    __extends(SSView, Backbone.View);
    function SSView() {
      this.render = __bind(this.render, this);
      this.initialize = __bind(this.initialize, this);
      SSView.__super__.constructor.apply(this, arguments);
    }
    SSView.prototype.initialize = function(rows, cols) {
      this.rows = rows;
      return this.cols = cols;
    };
    SSView.prototype.render = function() {
      var cellView, col, i, j, row, table, _ref, _ref2;
      table = $("<table/>");
      for (i = 1, _ref = this.rows; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
        row = $("<tr/>");
        table.append(row);
        for (j = 1, _ref2 = this.cols; 1 <= _ref2 ? j <= _ref2 : j >= _ref2; 1 <= _ref2 ? j++ : j--) {
          cellView = new CellView({
            model: new CellModel
          });
          cellView.render();
          col = $("<td/>");
          col.append(cellView.el);
          row.append(col);
        }
      }
      return $(this.el).html(table);
    };
    return SSView;
  })();
}).call(this);
