//= require rails-ujs
//= require activestorage
//= require jquery3
//= require vendor/jquery.mCustomScrollbar.min
//= require vendor/select2.full.min
//= require bootstrap-sprockets
//= require jquery-ui/widgets/datepicker
//= require vendor/jquery.mask.min
//= require profile
//= require_tree .

// INFO: Set CSRF-TOKEN to each Ajax requests
$(function(){
  jQuery.ajaxSetup({
    beforeSend: function(xhr) {
      xhr.setRequestHeader("Accept", "text/javascript");
      var csrf_meta_tag = jQuery('meta[name="csrf-token"]');
      if (csrf_meta_tag) {
        xhr.setRequestHeader('X-CSRF-Token', csrf_meta_tag.attr('content'));
      }
    }
  });

  jQuery.each( [ "put", "delete" ], function( i, method ) {
    jQuery[ method ] = function( url, data, callback, type ) {
      if ( jQuery.isFunction( data ) ) {
        type = type || callback;
        callback = data;
        data = undefined;
      }

      return jQuery.ajax({
        url: url,
        type: method,
        dataType: type,
        data: data,
        success: callback
      });
    };
  });

  // TODO: Need add Globar AJAX progress
  // $.ajaxSetup({
  //     beforeSend: function(){
  //       // $(".button").button("disable");
  //       alert('IAM IN BEFORE');
  //     },
  //     complete: function(){
  //       alert('IAM IN PAST');
  //     }
  // });
});
