class InvestAccountsController < AccountsController
  def create
    account = current_user.invest_accounts.new(params.require(:account).permit(*permitted_attrs))
    account.plaid_token = PlaidService.exchange(public_token: account.public_token)
    # TODO: This need only for detecting in realtime ability to get dwolla processor token
    # Should be moved to background job in the future
    dwolla_token = PlaidService.fetch_dwolla_processor_token(account.plaid_token, account.uid)
    account.dwolla_token = dwolla_token

    head :no_content, status: :created if account.save
  end

  def new
    invest_account
  end
end
