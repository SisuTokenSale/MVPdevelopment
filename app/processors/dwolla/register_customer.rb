module Processors
  module Dwolla
    class RegisterCustomer
      attr_reader :dwolla, :account, :customer, :funding_source, :profile, :account_type

      def initialize(opts = {})
        raise(ArgumentError, 'Option :account_id or :account required!') if opts[:account].blank? && opts[:account_id].blank?

        @account = opts[:account] || Account.find(opts[:account_id])
        @account_type = account.type.underscore.split('_').first

        @funding_source = account.funding_source || account.build_funding_source
      end

      def process!
        return if funding_source.dwolla_registered?

        @profile = account.user.profile

        return unless profile.approved?

        @customer = profile.send(:"#{account_type}_customer") || profile.send(:"build_#{account_type}_customer")
        @dwolla = DwollaService.new

        Customer.transaction do
          register_customer unless customer.dwolla_registered?
          register_funding_source unless funding_source.dwolla_registered?
        end
      end

      private

      def register_funding_source
        funding_source.customer = customer
        funding_source.save! if funding_source.new_record? # INFO: For build business_name with FundingSource ID
        funding_source.link = dwolla.register_funding_source(
          customer_link: customer.link,
          business_name: funding_source.business_name,
          dwolla_token: account.dwolla_token
        )

        funding_source.save!
      end

      def register_customer
        customer.save! if customer.new_record? # INFO: For build business_name with Customer ID
        customer.link = dwolla.register_customer request_body: request_body
        customer.save!
      end

      def request_body
        send(:"#{customer.customer_type.underscore}_body")
      end

      # INFO: [unverified, personal, business, receive-only]
      # Magic methods for fill body related to customer_type
      def business_body
        personal_body
      end

      def unverified_body
        full_body.slice(:businessName, :firstName, :lastName, :email, :type, :dateOfBirth, :ssn)
      end

      def receive_only_body
        unverified_body
      end

      def personal_body
        full_body.slice(:firstName, :lastName, :email, :type, :address1, :city, :state, :postalCode, :dateOfBirth, :ssn)
      end

      def full_body
        {
          businessName: customer.business_name,
          firstName: profile.first_name,
          lastName: profile.last_name,
          email: customer.email,
          type: customer.customer_type,
          address1: profile.street,
          city: profile.city,
          state:  profile.state,
          postalCode: profile.zip,
          dateOfBirth: profile.dob.strftime('%Y-%m-%d'),
          ssn: profile.ssn&.last(4)
        }
      end
    end
  end
end
