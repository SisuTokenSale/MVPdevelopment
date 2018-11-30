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
      }).on('ajax:error', function(event) {
        let xhr = event.detail[2];
        $('.js-set-content').html(xhr.responseText);
        App.iset.applyFormListener();
        App.iset_form.init();
      });
    },

    applyOneTimeInvestmentFormListener: function(){
      $('form#js-set-one-time-investment').on('ajax:success', function(event) {
        App.shared.goToDashboard();
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
      $('.js-cancel-selected-investments').on('click', function(e){
        App.modals.cancelInvst.show({
          investSetId: e.target.dataset.id,
        });
      })

      App.modals.cancelInvst.onProceed(function(state){
        let opts = [];
        if (state.periodic){opts.push('investments');}
        if (state.transactions){opts.push('transactions');}
        App.modals.cancelInvst.setState({status: 'started'});

        $.delete(`/invest_sets/${state.investSetId}`,
          {options: {cancel: opts}},
          function(data, status, xhr) {
          App.modals.cancelInvst.setState({status: 'finished', action: 'dismiss'});
          App.shared.goToDashboard();
        });
      })
    },

    deleteTransactionListener: function(){
      $('.js-delete-transaction').on('click', function(e){
        let data = e.target.dataset;
        App.modals.deleteTrx.show({
          trxId: data.id,
          desc: data.description,
        });
      });

      App.modals.deleteTrx.onProceed(function(state){
        App.modals.deleteTrx.setState({status: 'started'});

        $.delete(`/invest_transactions/${state.trxId}`, {}, function(data, status, xhr) {
          App.modals.deleteTrx.setState({status: 'finished', action: 'dismiss'});
          App.shared.goToDashboard();
        });
      });
    },

    renderNewForm: function(){
      $.get(`/invest_sets/new`, {}, function(data, status, xhr) {
        $(`.js-set-content`).html(data);
        App.iset.applyFormListener();
        App.iset_form.init();
      })
    }
  };
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  // TODO: Will implemented after MVP $('.js-money_input').mask('#.##0,00', { reverse: true });
  App.iset.cancelSelectedInvestmentsListener();
  App.iset.deleteTransactionListener();
  App.iset.applyOneTimeInvestmentFormListener();
  App.iset.applyChangeListener();
  App.iset.applyFormListener();
  App.iset.transactionsStatusFilterListener();
});
