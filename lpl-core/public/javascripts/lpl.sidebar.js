/*  • lpl sidebar               */
/*    lepilo sidebar view       */

lpl.sidebar = $.klass({

  open: false,
  openWidth: 250,
  currentWidth: 0,
  
  initialize: function() {
    
    if ($.cookie('lpl_sidebar') == 'open') {
      this.open = true;
      this.show();
    } else if ($.cookie('lpl_sidebar') == 'closed') {
      this.open = false;      
      this.hide();
    } else if (!$.cookie('lpl_sidebar')) {
      if ((this.currentWidth = this.element.width()) > 10) {
        this.open = true;
      }
    }
    
    return this;
  },
  
  width: function() {
    this.currentWidth = this.element.width();
    return this.currentWidth;
  },
  
  resize: function() {
    // window - header (51px) - sidebar padding-bottom (10px) - shelf border (8px)
    this.element.css({'height': $(window).height() - 62});
  },
  
  show: function() {
    this.element.width(this.openWidth);
    this.currentWidth = this.element.width();
    this.open = true;
    $.cookie('lpl_sidebar', 'open', { path: "/"});
    lpl.layout.reLayout();
  },
  
  hide: function() {
    this.element.width(0);
    this.currentWidth = this.element.width();
    this.open = false;
    $.cookie('lpl_sidebar', 'closed', { path: "/"});
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