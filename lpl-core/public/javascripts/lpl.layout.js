/*
    • lpl layout
      lepilo application layout
*/

lpl.layout = {
  
  lplViews: ["feedback", "sidebar", "inspector", "shelf"],
  headerHeight: 54,
  centerWidth: 0,
  centerHeight: 0,
  
  /*  
      The layout elements to manage: 
      
      div#lpl_core_sidebar      – Holds the lepilo modules/predefined searches
      div#lpl_core_feedback     – Holds the Flash messages
      div#lpl_core_inspector    – Holds the Inspector (metadata)
      div#lpl_core_shelf        – Holds the lepilo Content Shelf
  */
  
  init: function() {
    
    // Hide any view toggle buttons in Layout, will only enable them if the elements are indeed part of the DOM 
    $("#lpl_core_header .icons-toggle > .icon.toggle").hide();
    
    // Initialize all the views – make sure the view's .js file is included (or that the class is there inside another .js file)
    $.each(this.lplViews, function() { 
      var currentView = this; 

      if ($("#lpl_core_" + currentView).is('*')) {
        lpl.layout[ currentView ] = $("#lpl_core_" + currentView).attachAndReturn( lpl[ currentView ] )[0];
        
        // Initialize the toggle elements 
        if ($("#toggle_" + currentView).is("*")) {
          // show the toggle element
          $("#toggle_" + currentView).show();
          // attach the toggle function 
          $("#toggle_" + currentView).data("view", currentView).mouseup(function(a) {
            lpl.layout[ $(this).data("view") ].toggle();
          });
        }
      }
    });
    
    // 
    // $("#cancel_layout").mouseup(function() {
    //   // $(this)  - The caller DOM element
    //   // self     - The Object instance registering the event
    //   self.cancel();
    // });
    // 
  },
  
  reLayout: function() {
    // Get the Sidebar and Inspector widths
    sW = lpl.layout.sidebar   ? lpl.layout.sidebar.width() : 0;
    iW = lpl.layout.inspector ? lpl.layout.inspector.width() : 0;
    fH = lpl.layout.feedback  ? lpl.layout.feedback.height() : 0;
    
    // Make sure lpl_core_main is not extending the document, so the dW is later calculater correctly 
    $("#lpl_core_main").css({"left": sW, "top": this.headerHeight + fH});
    $("#lpl_core_main").width($(window).width() - sW - iW - 200);
    
    // Get the document and window dimensions
    var dW = $(document).width();
    var dH = $(document).height();
    var wW = $(window).width();
    var wH = $(window).height();
    widthDelta = wW - dW;
    
    feedbackMargin = 0;
    
    // Do some resizing 
    if (lpl.layout.sidebar) {
      lpl.layout.sidebar.resize();
      feedbackMargin++;
    }
    
    if (lpl.layout.inspector) {
      lpl.layout.inspector.resize();
      feedbackMargin++;
    }
    
    if (lpl.layout.feedback) {
      if (feedbackMargin == 0)
        lpl.layout.feedback.resize({ "left": sW + 1, "width": dW - sW - iW - 2 });
      if (feedbackMargin == 1)
        lpl.layout.feedback.resize({ "left": sW + 3, "width": dW - sW - iW - 4 });
      if (feedbackMargin == 2)
        lpl.layout.feedback.resize({ "left": sW + 3, "width": dW - sW - iW - 6 });
    }
      
    
    $("#lpl_core_main").css({"width": dW - sW - iW - 20});
    
    // console.log("document width: " + dW);
    // console.log("window width: " + wW);
    // 
    // console.log("#lpl_core_main width: " + $("#lpl_core_main").width());
    // console.log("window width: " + wW);
  }
  
};

//$(document).ready(function(){
jQuery(function($) {
  lpl.layout.init();
  
  $(window).resize(function() {
    lpl.layout.reLayout();
  });
  
  // $(document).scroll(function() {
  //   lpl.layout.reLayout();
  //   lpl.layout.reLayout();
  // });
  
  lpl.layout.reLayout();
});