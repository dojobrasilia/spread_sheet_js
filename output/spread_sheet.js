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
    function CellView(model) {
      this.edit = __bind(this.edit, this);
      this.render = __bind(this.render, this);      this.model = model;
      this.model.bind('change', this.render, this);
      $('div').live('click', this.edit);
    }
    CellView.prototype.render = function() {
      this.el = $("<div>" + (this.model.get('value')) + "</div>");
      return this;
    };
    CellView.prototype.edit = function() {
      console.log('chamou');
      return this.el = $("<div><input type='text'/></div>");
    };
    return CellView;
  })();
}).call(this);
