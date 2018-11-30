(function() {
  this.App || (this.App = {});

  App.modals = {

    deleteTrx: {
      el: $('#delete-trx-modal'),
      setState: function(newState){
        return Object.assign(App.state.modals.deleteTrx, newState);
      },
      getState: function(){
        return App.state.modals.deleteTrx;
      },
      show: function(opts){
        let state = App.modals.deleteTrx.setState(opts);
        App.modals.deleteTrx.el.children().find('.modal-text').html(state.desc);
        App.modals.deleteTrx.el.modal("show");
      },
      onProceed: function(callback){
        App.modals.deleteTrx.el.on('hide.bs.modal', function(_e){
          let state = App.modals.deleteTrx.getState();
          if(state.action === 'proceed'){
            callback(state);
          }
        });
      },
      init: function(){
        $('.js-delete-trx-proceed-btn').on('click', function(e){
          App.modals.deleteTrx.setState({action: 'proceed'})
        });
      },
    },

    cancelInvst: {
      el: $('#cancel-invst-modal'),
      setState: function(newState){
        return Object.assign(App.state.modals.cancelInvst, newState);
      },
      getState: function(){
        return App.state.modals.cancelInvst;
      },
      show: function(opts){
        App.modals.cancelInvst.setState(opts);
        App.modals.cancelInvst.el.modal("show");
      },
      onProceed: function(callback){
        App.modals.cancelInvst.el.on('hide.bs.modal', function(_e){
          let state = App.modals.cancelInvst.getState();
          if(state.action === 'proceed'){
            callback(state);
          }
        });
      },
      init: function(){
        let proceedBtn = $('.js-cancel-invst-proceed-btn');
        let periodicEl = $('#cancel-investments');
        let transactionsEl = $('#cancel-transactions');

        periodicEl.prop('checked', App.modals.cancelInvst.getState().periodic);
        transactionsEl.prop('checked', App.modals.cancelInvst.getState().transactions);

        let isDisabled = function(){
          return !App.modals.cancelInvst.getState().periodic && !App.modals.cancelInvst.getState().transactions;
        };

        let refreshBtnState = function(){
          proceedBtn.prop('disabled', isDisabled);
        };

        proceedBtn.on('click', function(e){
          App.modals.cancelInvst.setState({ action: 'proceed' })
        });

        periodicEl.on('click', function(e){
          App.modals.cancelInvst.setState({ periodic: e.target.checked })
          refreshBtnState();
        });

        transactionsEl.on('click', function(e){
          App.modals.cancelInvst.setState({ transactions: e.target.checked })
          refreshBtnState();
        });

        refreshBtnState();
      }
    }
  };
}).call(this);

$(document).ready(function(){
  App.modals.cancelInvst.init();
  App.modals.deleteTrx.init();
});
