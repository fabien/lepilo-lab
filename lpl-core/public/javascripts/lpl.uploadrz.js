/*  • lpl uploadrz              */
/*    lepilo upload handling    */

lpl.uploadrz = {
  
  totalFiles: 0,
  currentFile: 0,
  
  fileDialogComplete: function (numFilesSelected, numFilesQueued) {
    try {
      if (numFilesQueued > 0) {
        totalFiles = numFilesQueued;
        this.startUpload();
      }
    } catch (ex) {
      this.debug(ex);
    }
  },
  
  // call after an upload started
  uploadStarted: function (file) {
    $("#lpl_uploadpop").show("slow");
    
    /*
    file upload popup element hierarchy
    
    %div#lpl_uploadpop.lpl_infopop.uploader
      %div.content
        %h1 Uploading files

        %div.file
          %h2 File 1
          %div.lpl_progress_bar_bg
            %div.lpl_progress_bar{ :style => "width:25%"}
          %div.info
            asdasd
    */
    lpl.fileProgress.setFilename(file.name);
    
  },
  
  // Blah handle the progress
  uploadProgress: function (file, bytesLoaded) {

    try {
      var percent = Math.ceil((bytesLoaded / file.size) * 100);

      lpl.fileProgress.setProgress(percent);

      if (percent === 100) {
        lpl.fileProgress.setStatus("Processing File...");
        lpl.fileProgress.toggleCancel(false, this);
      } else {
        lpl.fileProgress.setStatus("File " + (totalFiles - this.getStats().files_queued + 1) + " of " + totalFiles + ", Uploading " + file.size + " bytes...");
        lpl.fileProgress.toggleCancel(true, this);
      }
    } catch (ex) {
      this.debug(ex);
    }
  },

  uploadSuccess: function (file, serverData) {
    try {
      lpl.fileProgress.setStatus("Successfully uploaded File.");
    } catch (ex) {
      this.debug(ex);
    }
  },
  
  // call after upload ended
  uploadComplete: function (file) {
    try {
      if (this.getStats().files_queued > 0) {
        this.startUpload();
      } else {
        lpl.fileProgress.setTitle("Upload Complete");

        $("#lpl_uploadpop").fadeOut("slow");
        window.location = window.location;
      }
    } catch (ex) {
      this.debug(ex);
    }
  },
  
  // call on errors
  uploadError: function (file, errorCode, message) {
    lpl.debug = errorCode;
    $("#lpl_uploadpop").fadeOut("slow");
    //window.location = window.location;
    try {
      switch (errorCode) {
      case SWFUpload.UPLOAD_ERROR.FILE_CANCELLED:
        try {
          lpl.fileProgress.setStatus("Cancelled");
          lpl.fileProgress.setStatus("Stopped");
        }
        catch (ex1) {
          this.debug(ex1);
        }
        break;
      case SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED:
        try {
          lpl.fileProgress.setTitle("Upload Stopped");
          lpl.fileProgress.setStatus("Stopped");
          progress.toggleCancel(true);
        }
        catch (ex2) {
          this.debug(ex2);
        }
      case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
        lpl.fileProgress.setTitle("Upload Limit exceeded");
        lpl.fileProgress.setStatus("Stopped");
        break;
      default:
        alert(message);
        break;
      }

    } catch (ex3) {
      this.debug(ex3);
    }

  },

  fileQueueError: function (file, errorCode, message) {
    try {
      var errorName = "";
      if (errorCode === SWFUpload.errorCode_QUEUE_LIMIT_EXCEEDED) {
        errorName = "You have attempted to queue too many files.";
      }

      if (errorName !== "") {
        alert(errorName);
        return;
      }

      switch (errorCode) {
      case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
        message = "Zero Byte File";
        break;
      case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
        message = "File exceeds Size Limit";
        break;
      case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
        message = "Invalid File Type";
        break;
      default:
        alert(message);
        break;
      }

    } catch (ex) {
      this.debug(ex);
    }

  },

  cancelUploads: function () {
    $("#lpl_uploadpop").hide("fast");
  },

  abortUploads: function (src) {
    
  }
  
  
};



lpl.fileProgress = {
  
  setProgress: function (percentage) {
    $("#lpl_uploadpop div.lpl_progress_bar").css("width", percentage + "%");
  },
  
  setComplete: function () {
  },
  
  setError: function () {
  },
  
  setCancelled: function () {
  },

  setTitle: function (title) {
    $("#lpl_uploadpop h1").text(title);
  },

  setFilename: function (filename) {
    $("#lpl_uploadpop div.file h2").text(filename);
  },
  
  setStatus: function (status) {
    $("#lpl_uploadpop div.info").text(status);
  },

  toggleCancel: function (show, swfuploadInstance) {
    this.fileProgressElement.childNodes[0].style.visibility = show ? "visible" : "hidden";
    if (swfuploadInstance) {
      var fileID = this.fileProgressID;
      this.fileProgressElement.childNodes[0].onclick = function () {
        swfuploadInstance.cancelUpload(fileID);
        return false;
      };
    }
  }

};