(function() {
  this.App || (this.App = {});

  // INFO: Plaid Activities
  App.plaid = {
    accounts: {},
    // fields: ['plaid_token', 'uid', 'name', 'institution', 'account_type', 'iso_currency_code', 'balance'],
    openWidget: function(type){
      Plaid.create({
        apiVersion: 'v2',
        clientName: 'SISU',
        env: App.plaid.env,
        product: ['transactions'],
        key: App.plaid.publicKey,
        onSuccess: function(publicToken){
          App.plaid.getAccountsCallback(publicToken, type)
        }
      }).open();
    },

    getAccount: function(type, field, value){
      return $.grep(App.plaid.accounts[type], function(obj){return obj[field] === value;})[0]
    },

    changeAccountHandler: function(type){
      $.get(`/${type}_accounts/new`, {
      }, function(data, status, xhr) {
          $(`.js-${type}-content`).html(data);
          $(`.js-${type}-btn-area`).empty();
          App.plaid.openWidget(type);
      });
    },

    getPlaidAccounts: function(publicToken){
      return $.post(`/plaid.json`, {
        public_token: publicToken
      });
    },

    showError: function(type, message){
      $(`.js-${type}-container`).html(
        `<div class="alert alert-warning" role="alert">
          ${message}
        </div>`
      );
    },

    getAccountsCallback: function(publicToken, type){
      $(`.js-${type}-btn-area`).empty();
      $(`.js-${type}-container`).text("Please wait ...");

      App.plaid.getPlaidAccounts(publicToken).then(function(accounts, status, xhr){
        App.plaid.accounts[type] = accounts.plaid_accounts;
        $(`input[name='${type}_account[plaid_token]']`).val(xhr.getResponseHeader('X-PLAID-TOKEN'));

        App.plaid.applyHiddenFields(type, App.plaid.accounts[type][0]);
        $(`.js-${type}-container`).html(App.plaid.buildAccountsSelectBox(type));

        // INFO: Add selectBox listener
        $(`.js-${type}_accounts-box`).on('change', function(e){
          App.plaid.applyHiddenFields(type, App.plaid.getAccount(type, 'uid', $(e.target).val()));
        });
        // INFO: Add Save Submit to Form
        $(`.js-${type}-btn-area`).html(
          '<button type="submit" class="btn btn-outline-success">SAVE</button>'
        )

        // INFO: Add Save Submit Form Handler
        $(`form#js-${type}-create`).on('ajax:success', function(event) {
          var detail = event.detail;
          var data = detail[0], status = detail[1],  xhr = detail[2];

          $(`.js-${type}-content`).html(xhr.responseText);

          $(`.js-${type}-create-btn`).on('click', function(e) {
            App.plaid.openWidget(type);
          });

          // INFO: Click Change Account Button
          $(`.js-${type}-change-btn`).on('click', function(e) {
            App.plaid.changeAccountHandler(type)
          });
          App.dashboard.applyGlobalListeners();
        });
      }, function(xhr, status, err){
        let error = xhr.responseJSON.error;
        App.plaid.showError(type, error.message);
        $(`.js-${type}-btn-area`).html(
          `<button type="button" class="js-${type}-change-btn btn btn-outline-warning">SELECT ANOTHER</button>`
        )
        $(`.js-${type}-change-btn`).on('click', function(e) {
          App.plaid.changeAccountHandler(type)
        });
        App.dashboard.applyGlobalListeners();
      });
    },

    applyHiddenFields: function(type, account){
      // $(`input[name='${type}_account[uid]']`).val(account['uid']);
      $(`input[name='${type}_account[name]']`).val(account['official_name']);
      $(`input[name='${type}_account[institution]']`).val(account['institution_name']);
      $(`input[name='${type}_account[account_type]']`).val(account['type']);
      $(`input[name='${type}_account[iso_currency_code]']`).val(account['iso_currency_code']);
      $(`input[name='${type}_account[balance]']`).val(account['available_balance']);
    },

    buildAccountsSelectBox(type){
     var content = `<select class="form-control js-${type}_accounts-box" name="${type}_account[uid]">`;
      content += App.plaid.accounts[type].map(function(account){
        return `<option value="${account.uid}" ${account.disabled == true ? 'disabled' : ''}>${account.full_name}</option>`;
      }).join('');

     content += '</select>';
     return content;
    }
  }
}).call(this);

// INFO: Shared CallBacks
$(document).ready(function(){
  $('.js-source-create-btn').on('click', function(e) {
    App.plaid.openWidget('source');
  });

  $('.js-invest-create-btn').on('click', function(e) {
    App.plaid.openWidget('invest');
  });


  $('.js-source-change-btn').on('click', function(e) {
    App.plaid.changeAccountHandler('source');
  });

  $('.js-invest-change-btn').on('click', function(e) {
    App.plaid.changeAccountHandler('invest');
  });
});

