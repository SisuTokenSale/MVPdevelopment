module Processors
  module Plaid
    class FetchTransactions
      def initialize(opts = {}); end

      def process!
        true
        # UserMailer.with(
        #   subject: 'Plaid Fetch Transactions start',
        #   message: 'Plaid Fetch Transactions works fine!'
        # ).transaction_mail.deliver_now
        # TODO: Select all active InvestSets source_account per user only with role 'user'
        # Fetch all transactions where date is past after last import
      end
    end
  end
end
