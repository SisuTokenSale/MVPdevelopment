module Processors
  module Dwolla
    # TODO: maybe drop passing profile and use class
    # TODO: split to create and update modules and base
    module CustomerProcessor
      VERIFIED_CUSTOMER_ALLOWED_FIELDS = %i[email address1 city state postalCode phone]
      UNVERIFIED_CUSTOMER_ALLOWED_FIELDS = %i[firstName lastName email address1 city state postalCode phone]

      def self.call(profile)
        profile.dwolla_customer_uid.present? ? update_customer(profile) : create_customer(profile)
      rescue DwollaV2::Error => e
        handle_dwolla_error(e, profile)
      end

      private_class_method

      def self.create_customer(profile)
        app_token = DwollaService.client

        customer = app_token.post('customers', request_body(profile))

        process_response(customer, profile)
      end

      def self.update_customer(profile)
        status = customer_status(profile.customer_uid)
        allowed_fields = allowed_fields_for_status(status)
        payload = request_body(profile).slice(*allowed_fields)
        app_token = ::DwollaService.client
        binding.pry

        customer = app_token.post("customers/#{profile.customer_uid}", payload)

        profile.update_attributes(dwolla_error_message: nil)
      end

      def self.request_body(profile)
        {
          firstName: profile.first_name,
          lastName: profile.last_name,
          email: profile.user.email + '1',
          type: 'personal',
          address1: profile.street,
          city: profile.city,
          state: profile.state,
          postalCode: profile.zip.to_i,
          dateOfBirth: profile.birth_date.strftime('%Y-%m-%d'),
          ssn: profile.ssn
        }
      end

      def self.customer_status(customer_uid)
        app_token = ::DwollaService.client
        response = app_token.get("customers/#{customer_uid}")
        response.status
      end

      # TODO: palceholder for suspended, deactivated, retry
      def self.allowed_fields_for_status(status)
        case status
        when 'unverified'
          UNVERIFIED_CUSTOMER_ALLOWED_FIELDS
        when 'verified'
          VERIFIED_CUSTOMER_ALLOWED_FIELDS
        else
          VERIFIED_CUSTOMER_ALLOWED_FIELDS
        end
      end

      def self.process_response(response, profile)
        Rails.logger.debug "DWOLLA SUCCESS: #{response}"

        profile.update_attributes(dwolla_customer_uid: response.response_headers['location'],
                                 dwolla_error_message: nil)
      end

      def self.handle_dwolla_error(error, profile)
        Rails.logger.debug "DWOLLA ERROR: #{error}"

        error_message = if error.respond_to?(:_embedded)
                          error._embedded['errors'].try(:[], 0).try(:[], :message)
                        else
                          error.message
                        end

        profile.update_attributes(dwolla_error_message: error_message)
      end
    end
  end
end
