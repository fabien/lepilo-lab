/*  • lpl shelf               */
/*    lepilo shelf view       */

lpl.shelf = $.klass({
  
  open: false,
  viewHeight: 0,
  openHeight: 255,
  height: 0,
  
  initialize: function() {
    
    this.reflowShelf();
    
    $("input", this.element).hide();
    
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
    $("input", this.element).show();
    this.reflowShelf();
    this.element.height(this.openHeight);
    this.element.width("100%");
    this.height = this.element.height();
    this.open = true;
    $.cookie('lpl_shelf', 'open', { path: "/"});
    lpl.layout.reLayout();
  },
  
  hide: function() {
    $("input", this.element).hide();
    this.reflowShelf();
    this.element.height(10);
    this.height = this.element.height();
    this.open = false;
    $.cookie('lpl_shelf', 'closed', { path: "/"});
    lpl.layout.reLayout();
  },
  
  toggle: function() {
    if (!this.open) {
      this.show();
    } else {
      this.hide();
    }
  },
  
  reflowShelf: function() {
    shelfContentItems = $(".icon-container", this.element).length + 1;
    newWidth = shelfContentItems * ($(".icon-container:first", this.element).width() + 5);
    $(".content", this.element).width(newWidth);
    return newWidth;
  }
  
  
});

$(window).load(function() {
  if (lpl.layout.shelf) {
    lpl.layout.shelf.reflowShelf();
  }
});
