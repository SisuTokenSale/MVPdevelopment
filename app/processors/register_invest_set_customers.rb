module Processors
  class RegisterInvestSetCustomers
    attr_reader :invest_set

    def initialize(opts = {})
      raise(ArgumentError, 'Option :id required!') if opts[:id].blank?

      @invest_set = InvestSet.includes(:source_account, :invest_account).find(opts[:id])
    end

    def process!
      return unless invest_set.ready?

      InvestSet.transaction do
        Processors::Dwolla::RegisterCustomer.new(account: invest_set.source_account).process!
        Processors::Dwolla::RegisterCustomer.new(account: invest_set.invest_account).process!
      end
    end
  end
end
