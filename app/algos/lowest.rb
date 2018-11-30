module Algos
  class Lowest
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :trx required!') if opts[:trx].blank?

      @trx = opts[:trx]
    end

    def calc_amount
      # INFO: Using delegator trx.rel_min_balance to related InvestSet
      (minimal_balance * trx.rel_min_balance * 0.01).to_f.round(2)
    end

    private

    def minimal_balance
      @minimal_balance ||= AccountTransaction.find_by_sql("
        SELECT
        count(*) AS count,
        date_trunc('month'::text, account_transactions.processed_on) AS month,
        SUM(account_transactions.deposit - account_transactions.credit) AS balance
        FROM account_transactions
        WHERE
          account_id = #{trx.source_account.id} AND
          processed_on >= '#{2.years.ago.to_date.to_s(:db)}' AND
          deposit > credit
        GROUP BY month
      ")&.min_by { |el| el.balance }&.balance&.to_f || 0.0
    end
  end
end
