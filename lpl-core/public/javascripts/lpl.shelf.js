/*  • lpl shelf               */
/*    lepilo shelf view       */

lpl.shelf = $.klass({
  
  open: false,
  viewHeight: 0,
  openHeight: 250,
  height: 0,
  
  initialize: function() {
    
    if ($.cookie('lpl_shelf') == 'open') {
      this.open = true;
      this.show();
    } else if ($.cookie('lpl_shelf') == 'closed') {
      this.open = false;      
      this.hide();
    } else if (!$.cookie('lpl_shelf')) {
      if ((this.viewHeight = this.element.height()) > 10) {
        this.open = true;
      }
    }
    
    return this;
  },
  
  show: function() {
    this.element.css({ "overflow" : "hidden" });
    this.element.height(this.openHeight);
    this.element.width("100%");
    this.height = this.element.height();
    this.open = true;
    $.cookie('lpl_shelf', 'open', { expires: 30, path: "/"});
    lpl.layout.reLayout();
  },
  
  hide: function() {
    this.element.css({ "overflow" : "hidden" });
    this.element.height(10);
    this.height = this.element.height();
    this.open = false;
    $.cookie('lpl_shelf', 'closed', { expires: 30, path: "/"});
    lpl.layout.reLayout();
  },
  
  toggle: function() {
    if (!this.open) {
      this.show();
    } else {
      this.hide();
    }
  }
  
});