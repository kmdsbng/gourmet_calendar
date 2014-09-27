// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery
//= require bootstrap/dist/js/bootstrap
//= require react/react
//= require react/JSXTransformer
//= require_tree .
//


$.ajaxSetup({
  beforeSend: function(xhr, settings) {
    if (settings.type == 'POST' || settings.type == 'PUT' || settings.type == 'DELETE') {
      if (!(/^http:.*/.test(settings.url) || /^https:.*/.test(settings.url))) {
        // Only send the token to relative URLs i.e. locally.
        xhr.setRequestHeader("X-CSRF-Token", $('meta[name="csrf-token"]').attr('content'));
      }
    }
  }
});

