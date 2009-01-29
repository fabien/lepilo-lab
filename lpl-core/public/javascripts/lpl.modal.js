/*  • lpl modal               */
/*    lepilo modal dialog     */

lpl.modal = $.klass({
  
  fetchURL: "",
  postURL: "",
  sendParams: "",
  
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
  
  /* recieves: url, title, type, params */
  show: function(options) {
    
    this.fetchURL = options.url;
    this.sendParams = options.params;
    
    $(".info", this.element).removeClass("yay").removeClass("fail");
    
    if(options.title)
      $(".info h1").html(options.title);
      
    if (options.type == "yay")   
      $(".info", this.element).addClass("yay");
    
    if (options.type == "fail")   
      $(".info", this.element).addClass("fail");
    
    this.fetch(this.fetchURL);
    this.openModal();
  },
  
  onmouseup: $.delegate({
    '.cancelmodal' : function(e){  this.cancelModal();  }
  }),
  
  fetch: function(url) {
    // popin content loaded via AJAX
    $.ajax({ 
      method: "get", url: this.fetchURL, data: this.sendParams, 
      beforeSend: function() {
        //this.popinContent.html(lpl.snippets.processing.gray);
        $("#lpl_modal_dialog .content", this.element).html(lpl.snippets.processing.gray);
        $("#lpl_modal_dialog .msg", this.element).html(lpl.messages.success)
      },
      complete: function() {
        //$(".loading", this.element).hide("blind", { direction: "vertical" }, 150);
        //$(".container .loading", this.element).hide("blind", { direction: "vertical" }, 150);
        $("#lpl_modal_dialog .msg", this.element).html(lpl.messages.success)
      },
      success: function(html){
        //$(".content").show("slow");
        $("#lpl_modal_dialog .msg", this.element).html(lpl.snippets.processing.gray)
        $("#lpl_modal_dialog .content", this.element).html(html).show("slide", { direction: "up" }, 350);
      } 
    });

  },
  
  putContent: function(bah) {
    $(".content", this.element).html(bah);
  },
  
  openModal: function() {
    $("#lpl_modal_dialog", this.element).hide();
    this.element.hide().css({ top: "0px" }).fadeIn(750, function () {
      $("#lpl_modal_dialog", this.element).show("slide", { direction: "up" }, 350);
    });
  },
  
  closeModal: function() {
    $('#lpl_modal_dialog .content').slideUp(500);
    $('#lpl_modal').fadeOut(750);
  },
  
  cancelModal: function() {
    this.closeModal();
  },
  
  resize: function(options) {
    newWidth = options.width || $('#lpl_modal_dialog', this.element).width();
    newPosition = ($(document).width() / 2) - (newWidth / 2);
    $("#lpl_modal_dialog", this.element).animate({ width: newWidth, left: newPosition }, 500);
  },
  
  center: function() {
    windowHalf = $(document).width() / 2;
    dialogWidth = $("#lpl_modal_dialog", this.element).width();
    $("#lpl_modal_dialog", this.element).css({ left: windowHalf - (dialogWidth/2) });
  }
});

$(document).ready(function(){
  if (modals = $('#lpl_modal').attachAndReturn(lpl.modal)) {
    lpl.app.modal = modals[0];
  };

  if (lpl.app.modal) {
    $(window).resize(function() {
      lpl.app.modal.center();
    });
  };

  
});

