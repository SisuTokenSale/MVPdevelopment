(function() {
  this.App || (this.App = {});

  App.shared = {
    goToDashboard: function(delay){
     delay = delay || 1000;
     window.setTimeout(function(){
       $(location).attr('href','/dashboard');
     }, delay);
    }
  };
}).call(this);
