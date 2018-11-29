module Processors
  module Dwolla
    class RegisterFundingSource
      attr_reader :dwolla, :account, :profile, :customer, :funding_source

      def initialize(opts = {})
        raise(ArgumentError, 'Option :account_id or :account required!') if opts[:account].blank? && opts[:account_id].blank?

        @account = opts[:account] || Account.find(opts[:account_id])
        @profile = account.user.profile

        raise(StandardError, "User #{account.user_id} haven't  profile") unless profile

        @customer = profile.send(:"#{account.type.underscore.split('_').first}_customer")
        @funding_source = account.funding_source || account.build_funding_source
      end

      def process!
        return unless profile.approved?

        return if funding_source.dwolla_registered?

        @dwolla = DwollaService.new
        register_funding_source!
      end

      private

      def register_funding_source!
        funding_source.customer = customer
        funding_source.save! if funding_source.new_record? # INFO: For build business_name with FundingSource ID
        funding_source.link = dwolla.register_funding_source(
          customer_link: customer.link,
          business_name: funding_source.business_name,
          dwolla_token: account.dwolla_token
        )

        funding_source.save!
      end
    end
  end
end
