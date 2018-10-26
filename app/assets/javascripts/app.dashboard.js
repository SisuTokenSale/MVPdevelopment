(function() {
  this.App || (this.App = {});

  App.dashboard = {
    showMoreDropdownListener: function(){
      $('.show-more').on('click', function(e) {
        e.preventDefault();

        let transHead = $(this).closest('.transactions-footer__head');
        let transBody = transHead.next();

        if(transHead.hasClass('opened')){
          transHead.removeClass('opened');
          transBody.removeClass('opened');
          $(this).html('Show more');
        }
        else{
          transHead.addClass('opened');
          transBody.addClass('opened');
          $(this).html('Show less');
        }
      });
    },

    applyTransListScrollbar: function(){
      $('.transactions-list-outer').mCustomScrollbar({
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
    },

    applyGlobalListeners: function(){
      App.dashboard.showMoreDropdownListener();
      App.dashboard.applyTransListScrollbar();
    }
  }
}).call(this);

$(document).ready(function(){
  App.dashboard.applyGlobalListeners();
});
