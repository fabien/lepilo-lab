/*  • lpl modal               */
/*    lepilo modal dialog     */

lpl.modal = $.klass({
  
  initialize: function() {
    
    this.center();
    
    if ($(".login_form").length > 0) {
      //this.element.show("slide", { direction: "up" }, 500);
      $("#lpl_modal_dialog", this.element).hide();
      this.element.hide().css({ top: "0px" }).fadeIn(750, function () {
        $(".info", this.element).addClass("fail");
        $("#lpl_modal_dialog", this.element).show("slide", { direction: "up" }, 350);
      });
      $(".info h1").html("Unauthorized access: please log in");
    } else {
      this.closeModal();
    }
  },
  
  openModal: function(message, type) {
    $('#lpl_modal').fadeIn(250);
    $('#lpl_modal_dialog .content').slideDown(250);
    $('#lpl_modal_dialog').slideDown(350);
  },
  
  onmouseup: $.delegate({
    '.cancelmodal' : function(e){  this.cancelModal();  }
  }),
  
  closeModal: function() {
    $('#lpl_modal_dialog .content').slideUp(500);
    $('#lpl_modal').fadeOut(750);
  },
  
  cancelModal: function() {
    this.closeModal();
  },
  
  center: function() {
    windowHalf = $(window).width() / 2;
    dialogWidth = $("#lpl_modal_dialog", this.element).width();
    $("#lpl_modal_dialog", this.element).css({ left: windowHalf - (dialogWidth/2) });
  }
});

$(document).ready(function(){
  if (modals = $('#lpl_modal').attachAndReturn(lpl.modal)) {
    lpl.app.modal = modals[0];
  };
  
  $(window).resize(function() {
    lpl.app.modal.center();
  });
  
});

