/*  • lpl app                  */
/*    lepilo app class         */

if (!lpl) var lpl = {};

lpl.app = function() {
  
  popin = function (popinOptions) {
    $("#lpl_inplace_ui").append("<div class='lpl_pop_in'><h1 class='title'></h1><div class='container'> Loading... </div> <div class='buttons'><div class='lpl_btn_square red cancelpopin'>Cancel<span></span></div><div class='lpl_right'><div class='lpl_btn_square green confirmpopin'>Save Text<span></span></div></div></div>    </div>");
    
    var realpopin = $(".lpl_pop_in:last-child").attachAndReturn(lpl.popin, popinOptions);
    return realpopin;
  };
  
};


/*
    • lpl debug
      lepilo debugging functions that we can override later on
*/


lpl.debug = {

  info: function (debugString) {
    console.log("lepilo INFO: " + debugString);
  },

  error: function (debugString) {
    console.error("lepilo ERROR: " + debugString);
  },

  warning: function (debugString) {
    console.warn("lepilo WARNING: " + debugString);
  }
  
};

/*                              */
/*    JS entry point            */
/*                              */

$(document).ready(function(){
  
  //  Initialize the modal dialog
  //$('#lpl_modal').attach(lpl.modal);
  
  //  Test the pop-in
  //$('.lpl_pop_in').attach(lpl.popin);
  
  // Initialize the shelf
  //$('#lpl_app_shelf').attach(lpl.shelf);
  
  //  Initialize the app layout functionality
  
  //$("textarea").autogrow();
  //$("ul.lpl_topics_container").attach(lpl.topic, {});
  
  $(document).animate({opacity: 1.0}, 3000).scrollTop(10);
});
