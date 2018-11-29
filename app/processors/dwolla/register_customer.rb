module Processors
  module Dwolla
    class RegisterCustomer < CustomerBase
      attr_reader :account

      def initialize(opts = {})
        if opts[:profile].blank? && opts[:profile_id].blank? && opts[:account].blank? && opts[:account_id].blank?
          raise(ArgumentError, 'Options :profile_id or :profile or :account_id or :account required!')
        end

        @account = opts[:account] || Account.find_by(id: opts[:account_id])
        @profile = opts[:profile] || Profile.find_by(id: opts[:profile_id]) || account&.user&.profile

        @customer_type = account&.type&.underscore&.split('_')&.first
      end

      def process!
        return unless profile.approved?

        @dwolla = DwollaService.new

        customer_type ? register_customer!(customer_type) : register_profile_customers!
      end

      private

      def register_profile_customers!
        %w[source invest].each { |customer_type| register_customer!(customer_type) }
      end

      def register_customer!(customer_type)
        # TODO: Not using SOLID, Need to fix in Future
        @customer = profile.send(:"#{customer_type}_customer") || profile.send(:"build_#{customer_type}_customer")
        return if customer.dwolla_registered?

        customer.save! if customer.new_record? # INFO: For build business_name with Customer ID
        customer.link = dwolla.register_customer request_body: request_body
        customer.save!
      end
    end
  end
end
