class PlaidFetchAccountInfoJob < ApplicationJob
  queue_as :plaid_fetch_account_info

  def perform(opts = {})
    Processors::Plaid::FetchAccountInfo.new(opts).process!
    # TODO: Should be applyed in the much more right place
    Processors::Dwolla::RegisterCustomer.new(account_id: opts[:id]).process!
  end
end
