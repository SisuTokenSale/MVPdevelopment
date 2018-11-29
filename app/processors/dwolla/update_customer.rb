module Processors
  module Dwolla
    class UpdateCustomer < CustomerBase
      def initialize(opts = {})
        if opts[:profile].blank? && opts[:profile_id].blank? && opts[:customer].blank? && opts[:customer_id].blank?
          raise(ArgumentError, 'Options :profile_id or :profile or :customer_id or :customer required!')
        end

        @customer = opts[:customer] || Customer.find_by(id: opts[:customer_id])
        @profile = opts[:profile] || Profile.find_by(id: opts[:profile_id]) || customer&.profile
      end

      def process!
        return unless profile.approved?

        @dwolla = DwollaService.new
        customer ? update_customer! : update_customers!
      end

      private

      def update_customers!
        [profile.source_customer, profile.invest_customer].compact.each do |customer|
          @customer = customer # TODO: Not using SOLID, Need to fix in Future
          update_customer!
        end
      end

      def update_customer!
        return unless customer.dwolla_registered?

        dwolla.update_customer link: customer.link, body: request_update_body
      end
    end
  end
end
