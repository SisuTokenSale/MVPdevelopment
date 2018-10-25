$(document).ready(function(){
  var $formControl = $('.form-control');
  if($formControl.length){

    $formControl.on('focus change input', function(){
      var formItem = $(this).parents('.form-item');
      if(!formItem.hasClass('focused'))
        formItem.addClass('focused');
    });

    $formControl.on('blur', function(){
      inputs_init($(this));
    });

    $formControl.each(function () {
      labels_check($(this));
    });
  }
  var $showPassword = $(".show-password");
  if($showPassword.length){
    $showPassword.on('click', function() {
      var $input = $('#'+$(this).data("toggle"));

      if ($input.attr('type') == 'password') {
        $input.attr('type', 'text');
        $(this).html('Hide');
      } else {
        $input.attr('type', 'password');
        $(this).html('Show');
      }
    });
  }
});

function labels_check(elem) {
  var formItem = elem.parents('.form-item');
  if(!formItem.hasClass('focused') && (elem.val() !== "" || elem.is(":-webkit-autofill") || elem.is("[autofocus]")))
    formItem.addClass('focused');
}

function inputs_init(elem) {
  if ( elem.val() == "" ) {
    elem.removeClass('filled');
    elem.parents('.form-item').removeClass('focused');
  } else {
    elem.addClass('filled');
  }
}