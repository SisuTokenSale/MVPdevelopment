module Algos
  class Sisu
    attr_reader :trx

    def initialize(opts = {})
      raise(ArgumentError, 'Option :trx required!') if opts[:trx].blank?

      @trx = opts[:trx]
    end

    def calc_amount
      final_investment_amount
    end

    def final_investment_amount
      fia = current_balance - balance_after_investment
      fia = max_investment if fia > max_investment
      fia = 5000 if fia > 5000
      fia = 0 if fia.negative?
      50 * (fia / 50).round
    end

    def balance_after_investment
      maximum_balance - expected_income
    end

    def maximum_balance
      probable_balance - expected_expenses
    end

    def max_investment
      current_balance - probable_balance
    end

    def probable_balance
      minimum_checking_account_balance > expected_income * 1.1 ? minimum_checking_account_balance : expected_income * 1.1
    end

    def expected_expenses
      [wma_expense, prev_month_expenses, prev_year_expenses].compact.max
    end

    def prev_month_expenses
      return unless prev_month_wma

      prev_month_wma[:expense]
    end

    def prev_year_expenses
      return unless prev_year_wma

      prev_year_wma[:expense]
    end

    def minimum_checking_account_balance
      expected_expenses * 0.2
    end

    def expected_income
      [wma_income, prev_month_income, prev_year_income].compact.min
    end

    def prev_month_income
      return unless prev_month_wma

      prev_month_wma[:income]
    end

    def prev_year_income
      return unless prev_year_wma

      prev_year_wma[:income]
    end

    # INFO: Income weighted moving average
    def wma_income
      @wma_income ||= months_collection.sum { |item| item[:income] * item[:k] }.to_f.round(2)
    end

    # INFO: Expense weighted moving average
    def wma_expense
      @wma_expense ||= months_collection.sum { |item| item[:expense] * item[:k] }.to_f.round(2)
    end

    def months_count
      @months_count ||= income_expenses.count
    end

    def prev_month_wma
      @prev_month_wma ||= months_collection.detect { |wma| wma[:month].to_s == previous_month.to_s }
    end

    def prev_year_wma
      @prev_year_wma ||= months_collection.detect { |wma| wma[:month].to_s == previous_year.to_s }
    end

    def previous_month
      Time.current.beginning_of_month.prev_month
    end

    def previous_year
      Time.current.beginning_of_month.prev_year
    end

    def current_balance
      trx.source_account.balance
    end

    def weight_devisor
      @weight_devisor ||= months_count * (months_count + 1) / 2.0
    end

    # INFO: Weighted moving average monthly, included Incomes & Expenses
    def months_collection
      @months_collection ||= income_expenses.zip(1..months_count).map do |item|
        object, month_int = item
        {
          income: object.income,
          expense: object.expense,
          k: month_int / weight_devisor,
          month: object.month
        }
      end
    end

    def income_expenses
      to = Time.current.beginning_of_month
      from = to.prev_year(2)
      @income_expenses ||= AccountTransaction.find_by_sql <<-SQL
        SELECT count(*) AS count,
        date_trunc('month'::text, account_transactions.processed_on) AS month,
        SUM(deposit) AS income,
        SUM(credit) AS expense
        FROM account_transactions
        WHERE
          account_id = #{trx.source_account.id} AND
          processed_on BETWEEN '#{from.to_date.to_s(:db)}' AND '#{to.to_date.to_s(:db)}'
        GROUP BY month
        ORDER BY month ASC;
      SQL
    end
  end
end
