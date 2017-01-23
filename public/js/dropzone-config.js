$(function() {
  Dropzone.options.replayUpload = {
    maxFiles: 1,
    init: function() {
      this.on('success', function(file, response) {
        window.location = response;
      })
    }
     
  }
});
