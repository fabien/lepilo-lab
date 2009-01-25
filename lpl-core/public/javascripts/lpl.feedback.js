/*  • lpl feedback              */
/*    lepilo feedback dialog    */

lpl.feedback = $.klass({
  
  open: false,
  viewWidth: 0,
  openWidth: 250,
  width: 0,
  
  initialize: function() {
    
    if ((this.viewWidth = this.element.width()) > 10) {
      this.open = true;
    };
    
    return this;
  },
  
  onmouseup: $.delegate({
    '#close_flash' : function(e){  this.hideFlash();  }
  }),
  
  height: function() {
    return this.element.height();
  },
  
  resize: function(options) {
    if (options.left)   {   this.element.css({ "left": options.left });      }
    if (options.width)  {   this.element.css({ "width": options.width });    }
  },
  
  hideFlash: function() {
    $("#lpl_flash", this.element).hide("slide", { direction: "up" }, 150, function() {
      lpl.layout.reLayout();
    });
  },
  
  toggle: function() {
    if (!this.open) {
      this.element.css({ "overflow" : "auto" });
      this.element.width(this.openWidth);
      this.width = this.element.width();
      this.open = true;
    } else {
      this.element.css({ "overflow" : "hidden" });
      this.element.width(0);
      this.width = this.element.width();
      this.open = false;
    }
    lpl.layout.reLayout();
  }

});