class InitTransactionJob < ApplicationJob
  queue_as :init_transaction

  def perform(opts = {})
    Processors::InitTransaction.new(opts).process!
  end
end
