class InvestTransactionsJob < ApplicationJob
  queue_as :invest_transactions

  def perform
    Processors::InvestTransactions.new.process!
  end
end
