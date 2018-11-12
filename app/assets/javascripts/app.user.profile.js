$(document).ready(function(){
  //navbar user menu
  var $userToggle = $("#user-menu-toggle");
  var $userDrop = $("#user-menu-dropdown");
  if($userToggle.length && $userDrop.length){
    $userToggle.on('click', function(e) {
      e.preventDefault();

      if($userDrop.hasClass('opened')){
        $userDrop.removeClass('opened');
        $(this).removeClass('opened');
      }
      else{
        $userDrop.addClass('opened');
        $(this).addClass('opened');
      }
    });

    $(document).on('click', function (e) {
      // if the target of the click isn't the container and isset dropdown
      if (!$userDrop.is(e.target) && $userDrop.has(e.target).length === 0
        && !$userToggle.is(e.target) && $userToggle.has(e.target).length === 0){

        if($userDrop.hasClass('opened') || $userToggle.hasClass('opened'))
          $($userDrop, $userToggle).removeClass('opened');
      }
    });
  }

  select2_init();
});

function select2_init() {
  var $select2Field = $('.main .select2-control');

  if($select2Field.length){
    $select2Field.select2({
      dropdownParent: $('.main'),
      containerCssClass: 'select2-field',
      minimumResultsForSearch: -1
    });
  }
}
