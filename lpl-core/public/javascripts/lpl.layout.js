/*
    • lpl layout
      lepilo application layout
*/

lpl.layout = function() {
  
  //  Holds a reference to the Instance of lpl.layout
  self = this;
  var headerHeight = 54;
  var shelfHeight = 250;
  var leftPanelWidth = 254;
  var rightPanelWidth = 304;
  var centerWidth;
  var centerHeight;
  
  var sidebarOpen = true;
  var inspectorOpen = true;
  var shelfOpen = false;
  
  /*  
      The layout elements to manage: 
      
      div#lpl_core_sidebar      – Holds the lepilo modules
      div#lpl_core_feedback    – Holds the content
      div#lpl_core_inspector     – Holds the Inspector
      div#lpl_core_shelf   – Holds the lepilo Content Library
  */
  
  this.init = function() {
    this.reLayout();
    
    $("#toggle_inspector").mouseup(function(a) {
      lpl.app.layout.toggleInspector()
    });
    
    $("#toggle_sidebar").mouseup(function(a) {
      lpl.app.layout.toggleSidebar()
    });

    $("#toggle_shelf").mouseup(function(a) {
      lpl.app.layout.toggleShelf()
    });

    $("#close_flash").mouseup(function(a) {
      lpl.app.layout.hideFlash()
    });

    $("#lpl_core_sidebar").width(leftPanelWidth);
    $("#lpl_core_inspector").width(rightPanelWidth);
    
    // 
    // $("#cancel_layout").mouseup(function() {
    //   // $(this)  - The caller DOM element
    //   // self     - The Object instance registering the event
    //   self.cancel();
    // });
    // 
  };
  
  this.reLayout = function() {
    //  Get the new document and window dimensions
    var dW = $(document).width();
    var dH = $(document).height();
    var wW = $(window).width();
    var wH = $(window).height();
    
    //  Resize the layout elements according to their current settings
    
    //  Here's where the juggling starts;
    //  
    //$("#lpl_core_feedback").height(1);
    
    $("#lpl_core_sidebar").css({"height": dH - 51});
    $("#lpl_core_feedback").css({"left": $("#lpl_core_sidebar").width() + $(window).scrollLeft() + 1});
    $("#lpl_core_inspector").css({"height": dH - 51});
    
    widthDelta = wW - dW;
    this.centerWidth = dW - $("#lpl_core_sidebar").width() - (wW - $("#lpl_core_inspector").offset().left) + widthDelta + 2;
    //$("#lpl_core_feedback").width(dW - $("#lpl_core_sidebar").width() - $("#lpl_core_inspector").width() - 2);
    $("#lpl_core_feedback").width(this.centerWidth);
    
    $("#lpl_core_main").css({"left": $("#lpl_core_sidebar").width() + 5, "top": headerHeight + $("#lpl_core_feedback").height(), "width": dW - $("#lpl_core_sidebar").width() - $("#lpl_core_inspector").width() - 10});
  };
  
  this.toggleInspector = function() {
    if (!inspectorOpen) {
      $("#lpl_core_inspector").css({ "overflow" : "auto" });
      $("#lpl_core_inspector").width(rightPanelWidth);
      inspectorOpen = true;
      this.reLayout();
    } else {
      $("#lpl_core_inspector").css({ "overflow" : "hidden" });
      $("#lpl_core_inspector").width(0);
      inspectorOpen = false;
      this.reLayout();
    }
  };

  this.toggleSidebar = function() {
    if (!sidebarOpen) {
      $("#lpl_core_sidebar").css({ "overflow" : "auto" });
      $("#lpl_core_sidebar").width(leftPanelWidth);
      sidebarOpen = true;
      this.reLayout();
    } else {
      $("#lpl_core_sidebar").css({ "overflow" : "hidden" });
      $("#lpl_core_sidebar").width(0);
      sidebarOpen = false;
      this.reLayout();
    }
  };

  this.toggleShelf = function() {
    if (!shelfOpen) {
      $("#lpl_core_shelf").css({ "overflow" : "hidden" });
      $("#lpl_core_shelf").height(shelfHeight);
      $("#lpl_core_shelf").width("100%");
      shelfOpen = true;
      this.reLayout();
    } else {
      $("#lpl_core_shelf").css({ "overflow" : "hidden" });
      $("#lpl_core_shelf").height(10);
      shelfOpen = false;
      this.reLayout();
    }
    this.reflowShelf();
  };

  this.reflowShelf = function() {
    shelfContentItems = $("#lpl_core_shelf .icon-container").length + 1;
    $("#lpl_core_shelf .content").width(shelfContentItems * ($("#lpl_core_shelf .icon-container:first").width() + 5) );
  };

  this.hideFlash = function() {
    $("#lpl_flash").hide("slide", { direction: "up" }, 150, this.reLayout );
  }
  
  return this;
};

$(document).ready(function(){
  lpl.app.layout = lpl.layout();
  lpl.app.layout.init();
  
  $(window).resize(function() {
    lpl.app.layout.reLayout();
  });
  $(document).scroll(function() {
    lpl.app.layout.reLayout();
  });

  lpl.app.layout.reLayout();
  
});
