/*                              */
/*    JS entry point            */
/*                              */

$(document).ready(function(){
    
  $("#lpl_core_shelf .icon-container").draggable({ 
    appendTo: "#container",
    revert: true,
    distance: 50,
    helper: "clone",
    //handle: ".image",
    start: function(event) { 
      var stuff = event; 
      $('.ui-draggable:last').addClass("lpl_dragged");
    },
    stop: function(event) { 
      //$(event.target).removeClass("lpl_dragged");   
    }
  });
  
  $(".inspector_list").sortable({ 
    /* connectWith: ["ul.lpl_topics_container > .container > .encapsulate"], */
    axis: "y",
    tolerance: "pointer",
    scrollSensitivity: 600
  }); 
  
});

$(window).load(function() {
  if (lpl.app.modal) {
    lpl.app.modal.show({ url: "", title: "Uploading File(s)" });
    //lpl.app.modal.center();
  }
});
