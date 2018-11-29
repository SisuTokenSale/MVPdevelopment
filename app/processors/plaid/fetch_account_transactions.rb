module Processors
  module Plaid
    class FetchAccountTransactions
      attr_reader :account

      def initialize(opts = {})
        raise(ArgumentError, 'Option :account or :id required!') if opts[:account].blank? && opts[:id].blank?

        @account = opts[:account] || Account.find(opts[:id])
      end

      def process!
        clear_old_transactons!(account)

        transactions_for(account).each_slice(50).each do |trxs|
          AccountTransaction.import build_trxs_pull(account, trxs), on_duplicate_key_ignore: true
        end
      end

      private

      def clear_old_transactons!(account)
        account.account_transactions.where('processed_on <= ?', 2.years.ago.to_date).delete_all
      end

      def build_trxs_pull(account, trxs)
        trxs.map do |trx|
          t = trx.with_indifferent_access
          AccountTransaction.new(
            account_id: account.id,
            uid: t[:transaction_id],
            processed_on: t[:date]&.to_date,
            iso_currency_code: t[:iso_currency_code],
            name: t[:name],
            deposit: (t[:amount] > 0.0 ? t[:amount].abs : 0.0),
            credit: (t[:amount] < 0.0 ? t[:amount].abs : 0.0)
          )
        end
      end

      def transactions_for(account)
        from_date = account.account_transactions.maximum(:processed_on) || 2.years.ago.to_date
        service = PlaidService.new(access_token: account.plaid_token)
        service.transactions(uid: account.uid, from: from_date, to: Time.zone.today)
      end
    end
  end
end
