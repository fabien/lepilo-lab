/*
    • lpl layout
      lepilo application layout
*/

lpl.layout = function() {
  
  //  Holds a reference to the Instance of lpl.layout
  self = this;
  var headerHeight = 54;
  var shelfHeight = 200;
  var leftPanelWidth = 254;
  var rightPanelWidth = 304;
  var centerWidth;
  var centerHeight;
  
  var sidebarOpen = true;
  var inspectorOpen = true;
  var shelfOpen = false;
  
  /*  
      The layout elements to manage: 
      
      div#lpl_app_left      – Holds the lepilo modules
      div#lpl_app_center    – Holds the content
      div#lpl_app_right     – Holds the Inspector
      div#lpl_app_shelf   – Holds the lepilo Content Library
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

    $("#lpl_app_left").width(leftPanelWidth);
    $("#lpl_app_right").width(rightPanelWidth);
    
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
    //$("#lpl_app_center").height(1);
    
    $("#lpl_app_left").css({"height": dH - 51});
    $("#lpl_app_center").css({"left": leftPanelWidth + $(window).scrollLeft() + 1, "top": $(window).scrollTop() + headerHeight - 3});
    $("#lpl_app_right").css({"height": dH - 51});
    
    this.centerWidth = wW - leftPanelWidth - (wW - $("#lpl_app_right").offset().left);
    $("#lpl_app_center").width(dW - $("#lpl_app_left").width() - $("#lpl_app_right").width() - 2);
    
    $("#lpl_content").css({"left": $("#lpl_app_left").width() + 5, "top": headerHeight + $("#lpl_app_center").height(), "width": $(document).width() - $("#lpl_app_left").width() - $("#lpl_app_right").width() - 10});
  };
  
  this.toggleInspector = function() {
    if (!inspectorOpen) {
      $("#lpl_app_right").css({ "overflow" : "auto" });
      $("#lpl_app_right").width(rightPanelWidth);
      inspectorOpen = true;
      this.reLayout();
    } else {
      $("#lpl_app_right").css({ "overflow" : "hidden" });
      $("#lpl_app_right").width(0);
      inspectorOpen = false;
      this.reLayout();
    }
  };

  this.toggleSidebar = function() {
    if (!sidebarOpen) {
      $("#lpl_app_left").css({ "overflow" : "auto" });
      $("#lpl_app_left").width(leftPanelWidth);
      sidebarOpen = true;
      this.reLayout();
    } else {
      $("#lpl_app_left").css({ "overflow" : "hidden" });
      $("#lpl_app_left").width(0);
      sidebarOpen = false;
      this.reLayout();
    }
  };

  this.toggleShelf = function() {
    if (!shelfOpen) {
      $("#lpl_app_shelf").css({ "overflow" : "hidden" });
      $("#lpl_app_shelf").height(shelfHeight);
      $("#lpl_app_shelf").width("100%");
      shelfOpen = true;
      this.reLayout();
    } else {
      $("#lpl_app_shelf").css({ "overflow" : "hidden" });
      $("#lpl_app_shelf").height(10);
      shelfOpen = false;
      this.reLayout();
    }
  };
  
  this.hideFlash = function() {
    $("#lpl_flash").hide("slide", { direction: "up" }, 350, this.reLayout );
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
  
});
