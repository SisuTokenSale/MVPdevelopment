module Processors
  class InitTransaction
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :id required!') if opts[:id].blank?

      @trx = InvestTransaction.includes(:invest_set, source_account: [:funding_source], invest_account: [:funding_source]).find(opts[:id])
    end

    def process!
      Processors::Dwolla::InitTransaction.new(trx: trx).process!
    end
  end
end
