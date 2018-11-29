module Processors
  module Dwolla
    class UpdateCustomer < CustomerBase
      def initialize(opts = {})
        raise(ArgumentError, 'Options :customer or :customer_id required!') if opts[:customer].blank? && opts[:customer_id].blank?

        @customer = opts[:customer] || Customer.find_by(id: opts[:customer_id])
        @customer_type = customer.type.underscore.split('_').first
        @profile = customer.profile
      end

      def process!
        return unless customer.dwolla_registered?

        @dwolla = DwollaService.new

        dwolla.update_customer link: customer.link, body: request_update_body
      end
    end
  end
end
