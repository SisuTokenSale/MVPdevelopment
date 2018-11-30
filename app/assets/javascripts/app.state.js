(function() {
  this.App || (this.App = {});

  App.state = {
    iset_form: {
      current: 'daily',
    },

    modals: {
      deleteTrx: {
        action: 'dismiss',
      },
      cancelInvst: {
        periodic: true,
        transactions: true,
        action: 'dismiss',
      },
    }
  };
}).call(this);
