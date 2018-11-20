module Processors
  module Plaid
    class FetchBalances
      attr_reader :service

      def initialize(opts = {}); end

      def process!
        InvestSet.activated.includes(:source_account, :invest_account).find_each(batch_size: 30).each do |is|
          next unless is.ready?

          InvestSet.transaction do
            is.source_account.update! balance: balance_for(is.source_account)
            is.invest_account.update! balance: balance_for(is.invest_account)
          end
        end
      end

      private

      def balance_for(account)
        service = PlaidService.new(access_token: account.plaid_token)
        service.find_by(uid: account.uid)&.available_balance || account.balance
      end
    end
  end
end
