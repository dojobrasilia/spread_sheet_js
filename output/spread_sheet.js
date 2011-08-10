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
    CellView.prototype.className = 'cell';
    CellView.prototype.events = {
      'click span': 'edit',
      'blur input': 'blur'
    };
    CellView.prototype.initialize = function() {
      return this.model.bind('change', this.render);
    };
    CellView.prototype.render = function() {
      $(this.el).html("<span>" + (this.model.get('value')) + "</span>");
      return this;
    };
    CellView.prototype.edit = function() {
      var input;
      input = $("<input type='text' value=" + (this.model.get('value')) + ">");
      $(this.el).html(input);
      return input.focus();
    };
    CellView.prototype.blur = function() {
      return $(this.el).html("<span> " + (this.model.get('value')) + " </span>");
    };
    return CellView;
  })();
}).call(this);
