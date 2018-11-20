class PlaidFetchBalancesJob < ApplicationJob
  queue_as :plaid_fetch_balances

  def perform
    Processors::Plaid::FetchBalances.new.process!
  end
end
