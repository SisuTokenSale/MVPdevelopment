module Processors
  module Plaid
    class FetchBalances
      def initialize(opts = {}); end

      def process!
        InvestSet.activated.includes(:source_account, :invest_account).find_each(batch_size: 30).each do |is|
          next unless is.ready?

          InvestSet.transaction do
            Processors::Plaid::FetchAccountBalance.new(account: is.source_account).process!
            Processors::Plaid::FetchAccountBalance.new(account: is.invest_account).process!
          end
        end
      end
    end
  end
end
