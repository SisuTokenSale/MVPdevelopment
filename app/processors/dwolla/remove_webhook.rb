module Processors
  module Dwolla
    class RemoveWebhook
      attr_reader :dwolla, :link

      def initialize(opts = {})
        raise(ArgumentError, 'Option :link required!') if opts[:link].blank?

        @dwolla = DwollaService.new
        @link = opts[:link]
      end

      def process!
        dwolla.remove_webhook link: link
      end
    end
  end
end
