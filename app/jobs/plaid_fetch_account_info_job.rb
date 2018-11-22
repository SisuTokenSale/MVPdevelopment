class PlaidFetchAccountInfoJob < ApplicationJob
  queue_as :plaid_fetch_account_info

  def perform(opts = {})
    return unless opts[:id]

    account = Account.find(opts[:id])

    Processors::Plaid::FetchAccountInfo.new(account: account).process!
    Processors::Plaid::FetchAccountBalance.new(account: account).process!
    Processors::Plaid::FetchAccountTransactions.new(account: account).process!
    Processors::Dwolla::RegisterCustomer.new(account: account).process!
    Processors::Dwolla::RegisterFundingSource.new(account: account).process!
  end
end
