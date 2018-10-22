module Processors
  module Dwolla
    class FetchTokens
      attr_reader :id, :account, :opts

      def initialize(args)
        @opts = args[0]
        @id = @opts[:id]
        raise(ArgumentError, 'Option :id required!') unless @id

        @account = Account.find(@id)
      end

      def process!
        dwolla_token = PlaidService.fetch_dwolla_processor_token(account.plaid_token, account.uid)

        if dwolla_token
          account.update!(dwolla_token: dwolla_token)

          UserMailer.with(
            subject: 'Dwolla processor token',
            message: "Setup successfully for #{account.name}"
          ).transaction_mail.deliver_now
        else
          UserMailer.with(
            subject: 'Error For set Dwolla Processor token',
            message: "Unsuccess set for #{account.name}"
          ).transaction_mail.deliver_now
        end
        # TODO: Select all active InvestSets source_account & invest_account without dwolla_token per user
        # Get dwolla_token for each collected account using next algo:
        # - dwolla = PlaidService.client.processor.dwolla.processor_token.create(access_token, account.uid)
        # - Account.update_attributes!(dwolla_token: dwolla['processor_token'])
      end
    end
  end
end
