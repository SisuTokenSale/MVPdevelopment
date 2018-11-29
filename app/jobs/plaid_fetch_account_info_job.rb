class PlaidFetchAccountInfoJob < ApplicationJob
  queue_as :plaid_fetch_account_info

  def perform(opts = {})
    return unless opts[:id]

    account = Account.find(opts[:id])

    Processors::Plaid::FetchAccountInfo.new(account: account).process!
    Processors::Plaid::FetchAccountBalance.new(account: account).process!
    Processors::Plaid::FetchAccountTransactions.new(account: account).process!

    # INFO: Profile was created or updated in Processors::Plaid::FetchAccountInfo processor
    Processors::Dwolla::RegisterCustomer.new(
      profile: account.user.profile,
      customer_type: account&.type&.underscore&.split('_')&.first
    ).process!

    Processors::Dwolla::RegisterFundingSource.new(account_id: account.id).process!
  end
end
