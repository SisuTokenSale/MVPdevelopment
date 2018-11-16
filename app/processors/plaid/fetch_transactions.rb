module Processors
  module Plaid
    class FetchTransactions
      def initialize(opts = {}); end

      def process!
        InvestSet.active.includes(:source_account, :invest_account).find_each(batch_size: 30).each do |is|
          next unless is.ready?

          # INFO: Delete transactions oldest then 2 years
          clear_old_transactons(is.source_account)
          clear_old_transactons(is.invest_account)

          transactions_for(is.source_account).each_slice(50).each do |trxs|
            AccountTransaction.import build_trxs_pull(is.source_account, trxs), on_duplicate_key_ignore: true
          end

          transactions_for(is.invest_account).each_slice(50).each do |trxs|
            AccountTransaction.import build_trxs_pull(is.invest_account, trxs), on_duplicate_key_ignore: true
          end
        end
      end

      private

      def clear_old_transactons(account)
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
