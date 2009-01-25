/*  • lpl inspector               */
/*    lepilo inspector view       */

lpl.inspector = $.klass({
  
  open: false,
  openWidth: 250,
  currentWidth: 0,
  
  initialize: function() {
    
    if ((this.currentWidth = this.element.width()) > 10) {
      this.open = true;
    };
    
    return this;
  },

  width: function() {
    this.currentWidth = this.element.width();
    return this.currentWidth;
  },
  
  resize: function() {
    // window - header (51px) - inspector padding-bottom (10px) - shelf border (8px)
    this.element.css({"height": $(window).height() - 69});
  },
  
  toggle: function() {
    if (!this.open) {
      this.element.css({ "overflow" : "auto" });
      this.element.width(this.openWidth);
      this.currentWidth = this.element.width();
      this.open = true;
    } else {
      this.element.css({ "overflow" : "hidden" });
      this.element.width(0);
      this.currentWidth = this.element.width();
      this.open = false;
    }
    lpl.layout.reLayout();
  }
  
});