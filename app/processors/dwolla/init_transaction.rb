module Processors
  module Dwolla
    class InitTransaction
      attr_reader :dwolla, :trx, :invest_set, :source_account, :invest_account

      def initialize(opts = {})
        raise(ArgumentError, 'Option :id or :trx required!') if opts[:id].blank? && opts[:trx].blank?

        @trx = opts[:trx] || InvestTransaction.includes(:invest_set, source_account: [:funding_source], invest_account: [:funding_source]).find(opts[:id])
      end

      def process!
        @invest_set = trx.invest_set

        return unless trx.planned?

        return unless invest_set.ready?

        @source_account = trx.source_account
        @invest_account = trx.invest_account

        @dwolla = DwollaService.new

        send_transaction!
      end

      def send_transaction!
        trx.link = dwolla.init_transaction(body: request_body)
        trx.pending! if trx.link.present?
      end

      private

      def from_to_note
        "from #{source_account.name}, #{source_account.institution} to #{invest_account.name}, #{invest_account.institution}"
      end

      def note
        case trx.investment_type
        when 'one_time'
          "One time investment #{trx.human_amount} #{from_to_note}"
        else
          "Frequency investment #{trx.human_amount} #{from_to_note}"
        end
      end

      def request_body
        {
          _links: {
            source: {
              href: source_account.funding_source.link
            },
            destination: {
              href: invest_account.funding_source.link
            }
          },
          amount: {
            currency: trx.iso_currency_code,
            value: trx.amount.to_s
          },
          metadata: {
            paymentId: trx.id.to_s,
            note: note
          },
          correlationId: trx.correlation_id
        }
      end
    end
  end
end
