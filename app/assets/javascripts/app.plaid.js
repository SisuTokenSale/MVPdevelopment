(function() {
  this.App || (this.App = {});

  // INFO: Plaid Activities
  App.plaid = {
    accountSuccess: $('#account-success'),

    openWidget: function(type, product){
      Plaid.create({
        apiVersion: 'v2',
        clientName: 'SISU',
        env: App.plaid.env,
        product: product,
        key: App.plaid.publicKey,
        onSuccess: function(publicToken, accountInfo){
          App.profile.fetchStatus().then(function(response){
            if(response.profile.status === 'ssn_dob_completed'){
              // INFO: SSN & DOB exist, just create Account
              App.plaid.createAccount(type, publicToken, accountInfo);
            } else {
              // INFO: SSN & DOB doesn't exist, need to add DOB & SSN
              App.profile.withSSNDOBModal(function(){
                App.plaid.createAccount(type, publicToken, accountInfo);
              });
            }
          })
        },
        onExit: function(err, metadata) {
          // TODO: If need do something if user cancelled selection
        }
      }).open();
    },

    createAccount(type, publicToken, accountInfo){
      return $.post(`/${type}_accounts.json`, {
        'account[uid]': accountInfo['account']['id'],
        'account[mask]': accountInfo['account']['mask'],
        'account[name]': accountInfo['account']['name'],
        'account[public_token]': accountInfo['public_token'],
        'account[institution]': accountInfo['institution']['name'],
        'account[institution_id]': accountInfo['institution']['institution_id'],
        'account[account_type]': accountInfo['account']['type']
      }).then(function(){
        App.plaid.accountSuccess.modal('show').on('hide.bs.modal', function(e){
          App.shared.goToDashboard();
        });
      }).fail(function(result){
        // TODO: Should be better if standart Alert
        alert(result.responseJSON.error.message);
      });
    }
  }
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  $('.js-source-create-btn, .js-source-change-btn').on('click', function(e) {
    App.plaid.openWidget('source', ['auth', 'transactions', 'identity', 'assets', 'income']);
  });

  $('.js-invest-create-btn, .js-invest-change-btn').on('click', function(e) {
    App.plaid.openWidget('invest', ['transactions']);
  });
});
