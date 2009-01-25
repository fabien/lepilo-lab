/*  • lpl shelf               */
/*    lepilo shelf view       */

lpl.shelf = $.klass({
  
  open: false,
  viewHeight: 0,
  openHeight: 250,
  height: 0,
  
  initialize: function() {
    
    if ((this.viewHeight = this.element.height()) > 10) {
      this.open = true;
    };
    
    return this;
  },
  
  toggle: function() {
    if (!this.open) {
      this.element.css({ "overflow" : "hidden" });
      this.element.height(this.openHeight);
      this.element.width("100%");
      this.height = this.element.height();
      this.open = true;
      lpl.layout.reLayout();
    } else {
      this.element.css({ "overflow" : "hidden" });
      this.element.height(10);
      this.height = this.element.height();
      this.open = false;
      lpl.layout.reLayout();
    }
  }
  
});