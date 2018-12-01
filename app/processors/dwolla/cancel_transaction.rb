module Processors
  module Dwolla
    class CancelTransaction
      attr_reader :dwolla, :trx

      def initialize(opts = {})
        raise(ArgumentError, 'Option :id or :trx required!') if opts[:id].blank? && opts[:trx].blank?

        @trx = opts[:trx] || InvestTransaction.find(opts[:id])
      end

      def process!
        return unless trx.pending?

        @dwolla = DwollaService.new
        cancel_transaction!
      end

      # INFO: Can't use trx.cancelled! method, because can be start infinit recursion
      def cancel_transaction!
        status = dwolla.cancel_transaction(link: trx.link, body: request_body)
        return unless status == 'cancelled'

        trx.update(cancelled_at: Time.current, status: 'cancelled')
        NoticeService.transfer(trx, :cancelled)
      end

      private

      def request_body
        {
          status: 'cancelled'
        }
      end
    end
  end
end
