module Processors
  module Dwolla
    class FetchWebhooks
      attr_reader :dwolla

      def initialize
        @dwolla = DwollaService.new
      end

      def process!
        webhooks.each do |wh|
          db_wh = DwollaWebhook.find_or_initialize_by(uid: wh[:uid])
          db_wh.update(wh)
        end
      end

      private

      def webhooks
        @webhooks ||= dwolla.webhooks
      end
    end
  end
end
