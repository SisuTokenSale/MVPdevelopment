module Processors
  module Plaid
    class FetchIdentity
      attr_reader :id, :account, :opts

      def initialize(args)
        @opts = args[0]
        @id = @opts[:id]
        raise(ArgumentError, 'Option :id required!') unless @id

        @account = Account.find(@id)
      end

      def process!
        plaid_identity = PlaidService.account_identity(account.plaid_token, account.uid)
        account.update!(plaid_identity: plaid_identity) if plaid_identity
      end
    end
  end
end
