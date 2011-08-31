(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  window.CellModel = (function() {
    __extends(CellModel, Backbone.Model);
    function CellModel() {
      this.changed = __bind(this.changed, this);
      CellModel.__super__.constructor.apply(this, arguments);
    }
    CellModel.prototype.defaults = {
      value: '',
      text: ''
    };
    CellModel.prototype.initialize = function() {
      this.bind('change', this.changed);
      return this.changed();
    };
    CellModel.prototype.changed = function() {
      var m;
      if (this.get('value')[0] === '=') {
        m = this.get('ssview').models[this.get('value').substring(1)];
        m.bind('change:value', this.changed);
        return this.set({
          text: m.get('text')
        });
      } else {
        return this.set({
          text: this.get('value')
        });
      }
    };
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
        $(this.el).html("<span>" + (this.model.get('text')) + "</span>");
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
    SSView.prototype.models = {};
    SSView.prototype.initialize = function(rows, cols) {
      this.rows = rows;
      return this.cols = cols;
    };
    SSView.prototype.render = function() {
      var cellView, colIndex, letters, row, rowIndex, table, _ref, _ref2;
      table = $("<table/>");
      letters = ['', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
      for (rowIndex = 0, _ref = this.rows; 0 <= _ref ? rowIndex <= _ref : rowIndex >= _ref; 0 <= _ref ? rowIndex++ : rowIndex--) {
        row = $("<tr/>");
        table.append(row);
        for (colIndex = 0, _ref2 = this.cols; 0 <= _ref2 ? colIndex <= _ref2 : colIndex >= _ref2; 0 <= _ref2 ? colIndex++ : colIndex--) {
          if (rowIndex === 0) {
            row.append($('<th/>').text(letters[colIndex]));
          } else if (colIndex === 0) {
            row.append($('<th>').text(rowIndex));
          } else {
            this.models["" + letters[colIndex] + rowIndex] = new CellModel({
              ssview: this
            });
            cellView = new CellView({
              model: this.models["" + letters[colIndex] + rowIndex]
            });
            cellView.render();
            row.append($("<td/>").append(cellView.el));
          }
        }
      }
      $(this.el).html(table);
      return this;
    };
    return SSView;
  })();
}).call(this);
