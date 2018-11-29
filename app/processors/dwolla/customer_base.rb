module Processors
  module Dwolla
    class CustomerBase
      attr_reader :dwolla, :customer, :profile, :customer_type

      private

      def request_body
        send(:"#{customer.customer_type.underscore}_body")
      end

      def request_update_body
        case customer.customer_type
        when 'unverified'
          request_body.slice(:firstName, :lastName, :email, :businessName)
        when 'receive-only'
          request_body.slice(:firstName, :lastName, :email, :businessName)
        when 'personal'
          request_body.slice(:email, :ipAddress, :address1, :address2, :city, :state, :postalCode, :phone)
        when 'business'
          request_body.slice(:doingBusinessAs, :website)
        end
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
