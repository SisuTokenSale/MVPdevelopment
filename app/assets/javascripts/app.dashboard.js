$(document).ready(function(){

  //navbar user menu
  var $showMore = $(".show-more");

  if($showMore.length){
    $showMore.on('click', function(e) {
      e.preventDefault();

      var $transHead = $(this).closest('.transactions-footer__head');
      var $transBody = $transHead.next();
      var $transListOuter = $transBody.find('.transactions-list-outer');

      //if($transListOuter.hasClass())
      if(typeof $transListOuter.mCustomScrollbar === 'function')
        $transListOuter.mCustomScrollbar("update");

      if($transHead.hasClass('opened')){
        $transHead.removeClass('opened');
        $transBody.removeClass('opened');
        $(this).html('Show more');
      }
      else{
        $transHead.addClass('opened');
        $transBody.addClass('opened');
        $(this).html('Show less');
      }
    });
  }

  var $transListOuter = $('.transactions-list-outer');
  if($transListOuter.length){
    $transListOuter.mCustomScrollbar({
      theme:"light",
      alwaysShowScrollbar:true,
      autoDraggerLength: true,
      mouseWheelPixels: 30,
      mouseWheel:{
        deltaFactor: 0,
        normalizeDelta: true,
        preventDefault: true
      },
      scrollInertia: 0,
      scrollEasing: "easeInOut"
    });
  }
});
