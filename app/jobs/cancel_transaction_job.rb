class CancelTransactionJob < ApplicationJob
  queue_as :cancel_transaction

  def perform(opts = {})
    Processors::CancelTransaction.new(opts).process!
  end
end
