module Processors
  class InvestTransactions
    ALGOS_MAP = {
      'Algos::Fixed' => %w[daily weekly monthly],
      'Algos::Lowest' => %w[lowest],
      'Algos::Sisu' => %w[algo]
    }.freeze

    def process!
      process_expired_periodical_transactions!
      create_will_processed_transactions!
    end

    private

    def process_expired_periodical_transactions!
      InvestTransaction.periodical_will_processed.find_each(batch_size: 30).each do |trx|
        trx.update(amount: calc_amount(trx))
        Processors::Dwolla::InitTransaction.new(trx: trx).process!
      end
    end

    def calc_amount(trx)
      algo_class(trx.frequency).classify.new(trx: trx).calc_amount
    end

    def algo_class(frequency)
      ALGOS_MAP.detect { |_k, frequencies| frequency.in?(frequencies) }.first
    end

    def create_will_processed_transactions!
      InvestSet.activated.find_each(batch_size: 30).each do |invest_set|
        next unless invest_set.ready?
        # INFO: Skip if already has (planned or cancelled) periodical transactions
        next if invest_set.planned_periodical_transactions?

        trx = invest_set.invest_transactions.new(
          amount: invest_set.amount,
          investment_type: 'periodical',
          will_processed_at: calc_will_processed_at(invest_set.frequency)
        )

        trx.planned!
      end
    end

    def calc_will_processed_at(frequency)
      case frequency
      when 'daily'
        Time.current.next_day
      when 'weekly'
        Time.current.next_week
      when 'monthly'
        Time.current.next_month
      when 'lowest'
        Time.current.next_month.beginning_of_month
      when 'algo'
        Time.current.next_month.beginning_of_month
      end
    end
  end
end
