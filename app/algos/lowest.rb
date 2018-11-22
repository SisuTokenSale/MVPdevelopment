module Algos
  class Lowest
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :trx required!') if opts[:trx].blank?

      @trx = opts[:trx]
    end

    def calc_amount
      # TODO: Use delegator trx.rel_min_balance to related InvestSet
      @trx.amount
    end
  end
end
