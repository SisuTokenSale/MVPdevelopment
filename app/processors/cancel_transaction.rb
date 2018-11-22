module Processors
  class CancelTransaction
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :id required!') if opts[:id].blank?

      @trx = InvestTransaction.find(opts[:id])
    end

    def process!
      Processors::Dwolla::CancelTransaction.new(trx: trx).process!
    end
  end
end
