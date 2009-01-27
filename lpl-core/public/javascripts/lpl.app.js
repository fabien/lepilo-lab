/*  • lpl app                  */
/*    lepilo app class         */

if (!lpl) var lpl = {};

lpl.app = {
  
  popin: function (popinOptions) {
    $("#lpl_inplace_ui").append("<div class='lpl_pop_in'><h1 class='title'></h1><div class='container'> Loading... </div> <div class='buttons'><div class='lpl_btn_square red cancelpopin'>Cancel<span></span></div><div class='lpl_right'><div class='lpl_btn_square green confirmpopin'>Save Text<span></span></div></div></div>    </div>");
    
    var realpopin = $(".lpl_pop_in:last-child").attachAndReturn(lpl.popin, popinOptions);
    return realpopin;
  }
  
};


/*
    • lpl debug
      lepilo debugging functions that we can override later on
*/


lpl.debug = {

  info: function (debugString) {
    console.log(" • • • lepilo INFO: " + debugString);
  },

  error: function (debugString) {
    console.error(" • • • lepilo ERROR: " + debugString);
  },

  warning: function (debugString) {
    console.warn(" • • • lepilo WARNING: " + debugString);
  }
  
};

/*                              */
/*    JS entry point            */
/*                              */

$(document).ready(function(){
  
  // Fix up the buttons 
  $('.lpl_btn_square').append('<span></span>');
  $('.lpl_action_20').append('<span></span>');
  
  $('.edit').children('a:first-child').addClass('start');
  $('.edit').children('a:last-child').addClass('end');
  
  //  Initialize the modal dialog
  //$('#lpl_modal').attach(lpl.modal);
  
  //  Test the pop-in
  //$('.lpl_pop_in').attach(lpl.popin);
  
  // Initialize the shelf
  //$('#lpl_core_shelf').attach(lpl.shelf);
  
  //  Initialize the app layout functionality
  
  //$("textarea").autogrow();
  //$("ul.lpl_topics_container").attach(lpl.topic, {});
  
  // lpl.layout.reLayout();
  // A slightly delayed lpl.app.layout.reLayout call for Safari 
  $("#lpl_core_main").animate({opacity: 1.0}, 500, "linear", function(){ lpl.layout.reLayout(); });
  //$("#lpl_core_main").animate({opacity: 1.0}, 5000, "linear", function(){ lpl.layout.reLayout(); });
});

$(window).load(function() {
  lpl.layout.reLayout();
});