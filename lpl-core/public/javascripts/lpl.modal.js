/*  • lpl modal               */
/*    lepilo modal dialog     */

lpl.modal = $.klass({
  
  fetchURL: "",
  postURL: "",
  sendParams: "",
  
  initialize: function() {
    
    if ($(".login_form").length > 0) {
      //this.element.show("slide", { direction: "up" }, 500);
      $("#lpl_core_modal_dialog", this.element).hide();
      this.element.hide().css({ top: "0px" }).fadeIn(750, function () {
        $("h1", this.element).addClass("fail");
        $("#lpl_core_modal_dialog", this.element).show("slide", { direction: "up" }, 350);
      });
      $("h1", this.element).html("Unauthorized access: please log in");
    } else {
      this.closeModal();
    }
  },
  
  /* recieves: url, title, type, params */
  show: function(options) {
    
    this.fetchURL = options.url;
    this.sendParams = options.params;
    
    if(options.title != "") {
      $("h1", this.element).removeClass("yay").removeClass("fail");
      $("h1", this.element).show();
      $("h1", this.element).html(options.title);

      if (options.type == "yay") {
        $("h1", this.element).addClass("yay");
      }

      if (options.type == "fail") {
        $("h1", this.element).addClass("fail");
      }
      
    } else {
      $("h1", this.element).hide();
    }
    
    if (this.fetchURL && this.fetchURL != "") {
      this.fetch(this.fetchURL);
    }
    this.openModal();
  },
  
  onmouseup: $.delegate({
    '.cancelmodal' : function(e){  this.cancelModal();  }
  }),
  
  fetch: function(url) {
    this.center();
    // popin content loaded via AJAX
    $.ajax({ 
      method: "get", url: this.fetchURL, data: this.sendParams, 
      beforeSend: function() {
        //this.popinContent.html(lpl.snippets.processing.gray);
        //$("#lpl_core_modal_dialog .content", this.element).html(lpl.snippets.processing.gray);
        $("#lpl_core_modal_dialog .msg", this.element).html(lpl.snippets.processing.gray)
        $("#lpl_core_modal_dialog .msg", this.element).show();
      },
      complete: function() {
        //$(".loading", this.element).hide("blind", { direction: "vertical" }, 150);
        //$(".container .loading", this.element).hide("blind", { direction: "vertical" }, 150);
        //$("#lpl_core_modal_dialog .msg", this.element).html(lpl.messages.success);
        //$("#lpl_core_modal_dialog .msg", this.element).show();
      },
      success: function(html){
        //$(".content").show("slow");
        //$("#lpl_core_modal_dialog .msg", this.element).html(lpl.snippets.processing.gray)
        $("#lpl_core_modal_dialog .msg", this.element).hide();
        $("#lpl_core_modal_dialog .content", this.element).html(html);
      } 
    });

  },
  
  putContent: function(content) {
    $(".content", this.element).html(content);
  },
  
  putMessage: function(message) {
    $(".msg", this.element).html(message);
  },
  
  openModal: function() {
    this.center();

    $("#lpl_core_modal_dialog", this.element).hide();
    this.element.hide().css({ top: "0px" }).fadeIn(750, function () {
      $(".content", this.element).show();
      $("#lpl_core_modal_dialog", this.element).show("slide", { direction: "up" }, 500);
    });
  },
  
  closeModal: function() {
    $('.content', this.element).slideUp(500);
    $(this.element).fadeOut(750);
  },
  
  cancelModal: function() {
    this.closeModal();
  },
  
  resize: function(options) {
    if (options.width > $(document).width()) {
      options.width = $(document).width() - 20;
    }
    
    newWidth = options.width || $('#lpl_core_modal_dialog', this.element).width();
    newPosition = ($(document).width() / 2) - (newWidth / 2);
    $("#lpl_core_modal_dialog", this.element).animate({ width: newWidth, left: newPosition }, 500);
  },
  
  center: function() {
    windowHalf = $(document).width() / 2;
    dialogWidth = $("#lpl_core_modal_dialog", this.element).width();
    $("#lpl_core_modal_dialog", this.element).css({ left: windowHalf - (dialogWidth/2) });
  }
});

$(document).ready(function(){
  if (modals = $('#lpl_core_modal').attachAndReturn(lpl.modal)) {
    lpl.app.modal = modals[0];
  };

  if (lpl.app.modal) {
    $(window).resize(function() {
      lpl.app.modal.center();
    });
  };

  
});

