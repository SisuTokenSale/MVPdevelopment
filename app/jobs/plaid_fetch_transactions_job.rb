class PlaidFetchTransactionsJob < ApplicationJob
  queue_as :plaid_fetch_transactions

  def perform
    Processors::Plaid::FetchTransactions.new.process!
  end
end
