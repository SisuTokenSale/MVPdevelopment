module Processors
  module Dwolla
    class InitWebhook
      attr_reader :dwolla, :dwolla_webhook

      def initialize(opts = {})
        raise(ArgumentError, 'Option :id or :dwolla_webhook required!') if opts[:id].blank? && opts[:dwolla_webhook].blank?

        @dwolla_webhook = DwollaWebhook.find(opts[:id])
      end

      def process!
        @dwolla = DwollaService.new

        init_webhook!
      end

      def init_webhook!
        dwolla_webhook.link = dwolla.init_webhook(body: request_body)
        dwolla_webhook.save if dwolla_webhook.link.present?
      end

      private

      def request_body
        {
          url: dwolla_webhook.url,
          secret: dwolla_webhook.secret
        }
      end
    end
  end
end
