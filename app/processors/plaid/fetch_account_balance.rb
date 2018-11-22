module Processors
  module Plaid
    class FetchAccountBalance
      attr_reader :account

      def initialize(opts = {})
        raise(ArgumentError, 'Option :account or :account_id required!') if opts[:account].blank? && opts[:account_id].blank?

        @account = opts[:account] || Account.find(opts[:account_id])
      end

      def process!
        account.update! balance: balance_for(account)
      end

      private

      def balance_for(account)
        service = PlaidService.new(access_token: account.plaid_token)
        service.find_by(uid: account.uid)&.available_balance || account.balance
      end
    end
  end
end
