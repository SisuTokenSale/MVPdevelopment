(function() {
  this.App || (this.App = {});

  // INFO: InvestSet Activities
  App.iset = {
    renderNewForm: function(){
      $.get(`/invest_sets/new`, {
      }, function(data, status, xhr) {
        $(`.js-set-content`).html(data);
      });
    }
  };
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  $('.js-set-change-btn').on('click', function(e) {
    App.iset.renderNewForm();
  });
});

