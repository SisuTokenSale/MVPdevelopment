class PlaidFetchAccountInfoJob < ApplicationJob
  queue_as :plaid_fetch_account_info

  def perform(opts)
    Processors::Plaid::FetchAccountInfo.new(opts).process!
  end
end
