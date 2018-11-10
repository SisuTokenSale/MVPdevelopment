(function() {
  this.App || (this.App = {});

  // INFO: InvestSet Activities
  App.iset = {

    applyChangeListener: function(){
      $('.js-set-change-btn').on('click', function(e) {
        App.iset.renderNewForm();
      });
    },

    applyFormListener: function(){
      $('form#js-set-create').on('ajax:success', function(event) {
        App.shared.goToDashboard();
        // TODO: Will use this for Full Async I-face
        // let xhr = event.detail[2];
        // $('.js-set-content').html(xhr.responseText);
        // App.iset.applyChangeListener();
        // App.dashboard.applyGlobalListeners();
      }).on('ajax:error', function(event) {
        let xhr = event.detail[2];
        $('.js-set-content').html(xhr.responseText);
        App.iset.applyFormListener();
        App.dashboard.applyGlobalListeners();
      });
    },

    applyOneTimeInvestmentFormListener: function(){
      $('form#js-set-one-time-investment').on('ajax:success', function(event) {
        App.shared.goToDashboard();
        // TODO: Will use this for Full Async I-face
        // let xhr = event.detail[2];
        // $('.js-one-time-investment-container').html(xhr.responseText);
        // App.iset.getAndApplyTransactions('');
        // App.iset.applyOneTimeInvestmentFormListener();
      }).on('ajax:error', function(event) {
        let xhr = event.detail[2];
        $('.js-one-time-investment-container').html(xhr.responseText);
        App.iset.applyOneTimeInvestmentFormListener();
      });
    },

    getAndApplyTransactions: function(status){
      $.get(`/invest_sets/transactions`, { q: { status_in: [status] } }, function(htmlResponse) {
        $('.js-set-transactions-items').html(htmlResponse);
      });
    },

    transactionsStatusFilterListener: function(){
      $('.js-filter-set-transaction_status').on('change', function(e){
        App.iset.getAndApplyTransactions($(e.target).val());
      });
    },

    cancelSelectedInvestmentsListener: function(){
      let modalWindow = $('#confirm-cancel-selected-investments');
      $('.js-cancel-selected-investments').on('click', function(e){
        let invest_set_id = e.target.dataset.id;
        modalWindow.modal("show");

        modalWindow.on('hide.bs.modal', function(e){
          let activeElement = $(document.activeElement);

          if(activeElement.data().action === 'proceed'){
            console.log(`DELETE: /invest_sets/${invest_set_id}`)
            App.shared.goToDashboard();
          }
        });
      })
    },

    deleteTransactionListener: function(){
      let modalWindow = $('#confirm-delete-transaction');
      $('.js-delete-transaction').on('click', function(e){
        let trxId = e.target.dataset.id;

        modalWindow.modal('show')

        modalWindow.on('hide.bs.modal', function(e){
          let activeElement = $(document.activeElement);

          if(activeElement.data().action === 'proceed'){
            console.log(`POST: /invest_transactions/${trxId}`)
            App.shared.goToDashboard();
          }
        });
      })
    },



    renderNewForm: function(){
      $.get(`/invest_sets/new`, {}, function(data, status, xhr) {
        $(`.js-set-content`).html(data);
        App.iset.applyFormListener();
        App.dashboard.applyGlobalListeners();
      });
    }
  };
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  App.iset.cancelSelectedInvestmentsListener();
  App.iset.deleteTransactionListener();
  App.iset.applyOneTimeInvestmentFormListener();
  App.iset.applyChangeListener();
  App.iset.applyFormListener();
  App.iset.transactionsStatusFilterListener();
});
