class PlaidFetchTransactionsJob < ApplicationJob
  queue_as :plaid_fetch_transactions

  def perform(*_args)
    Processors::Plaid::FetchTransactions.new.process!
  end
end
