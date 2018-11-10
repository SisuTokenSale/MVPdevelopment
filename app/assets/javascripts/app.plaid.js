(function() {
  this.App || (this.App = {});

  // INFO: Plaid Activities
  App.plaid = {
    openWidget: function(type, product){
      Plaid.create({
        apiVersion: 'v2',
        clientName: 'SISU',
        env: App.plaid.env,
        product: product,
        key: App.plaid.publicKey,
        onSuccess: function(publicToken, accountInfo){
          $.post(`/${type}_accounts.json`, {
            'account[uid]': accountInfo['account']['id'],
            'account[mask]': accountInfo['account']['mask'],
            'account[name]': accountInfo['account']['name'],
            'account[public_token]': accountInfo['public_token'],
            'account[institution]': accountInfo['institution']['name'],
            'account[institution_id]': accountInfo['institution']['institution_id'],
            'account[account_type]': accountInfo['account']['type']
          }, function(response){
            App.shared.goToDashboard();
          }).fail(function(result){
            alert(result.responseJSON.error.message);
          });
        },
        onExit: function(err, metadata) {
          // TODO: If need do something if user cancelled selection
        }
      }).open();
    }
  }
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  $('.js-source-create-btn, .js-source-change-btn').on('click', function(e) {
    App.plaid.openWidget('source', ['auth', 'transactions', 'identity', 'assets', 'income']);
  });

  $('.js-invest-create-btn, .js-invest-change-btn').on('click', function(e) {
    App.plaid.openWidget('invest', ['auth', 'transactions']);
  });
});
