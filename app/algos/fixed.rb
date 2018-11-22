module Algos
  class Fixed
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :trx required!') if opts[:trx].blank?

      @trx = opts[:trx]
    end

    def calc_amount
      @trx.amount
    end
  end
end
