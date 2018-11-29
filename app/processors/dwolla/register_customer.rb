module Processors
  module Dwolla
    class RegisterCustomer < CustomerBase
      def initialize(opts = {})
        # INFO: opts[:customer_type] IN [source, invest]
        raise(ArgumentError, 'Options :customer_type required!') if opts[:customer_type].blank?

        raise(ArgumentError, 'Options :profile or :profile_id required!') if opts[:profile].blank? && opts[:profile_id].blank?

        @customer_type = opts[:customer_type]

        @profile = opts[:profile] || Profile.find_by(id: opts[:profile_id])

        @customer = profile.send(:"#{customer_type}_customer") || profile.send(:"build_#{customer_type}_customer")
      end

      def process!
        return unless profile.approved?

        # TODO: Need uncomment in production mode
        # If customer already exist in DB, should be check sync with Dwolla
        return if customer.dwolla_registered?

        @dwolla = DwollaService.new

        customer.save! if customer.new_record? # INFO: For build business_name with Customer ID
        customer.link = dwolla.register_customer body: request_body
        customer.save!
      end
    end
  end
end
