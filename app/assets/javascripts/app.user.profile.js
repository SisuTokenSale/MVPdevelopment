$(document).ready(function(){

  //navbar user menu
  var $userToggle = $("#user-menu-toggle");
  var $userDrop = $("#user-menu-dropdown");
  if($userToggle.length && $userDrop.length){
    $userToggle.on('click', function() {
      $userDrop.toggleClass('active');
    });

    $(document).on('mouseup', function (e) {
      // if the target of the click isn't the container and isset dropdown
      if (!$userDrop.is(e.target) && $userDrop.has(e.target).length === 0){
        if($userDrop.hasClass('active'))
          $userDrop.removeClass('active');
      }
    });
  }
});
