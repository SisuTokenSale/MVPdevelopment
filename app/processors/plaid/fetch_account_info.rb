module Processors
  module Plaid
    class FetchAccountInfo
      attr_reader :account

      def initialize(opts = {})
        raise(ArgumentError, 'Option :id or :account required!') if opts[:account].blank? && opts[:id].blank?

        @account = opts[:account] || Account.find(opts[:id])
      end

      def process!
        # TODO: raise if account.plaid_token doesn't exist
        # dwolla_token = PlaidService.fetch_dwolla_processor_token(account.plaid_token, account.uid)
        # account.dwolla_token = dwolla_token if dwolla_token

        plaid_account = PlaidService.new(access_token: account.plaid_token).account_data(uid: account.uid)
        if plaid_account
          account.iso_currency_code = plaid_account.iso_currency_code
          account.balance = plaid_account.available_balance
        end

        # TODO: Maybe need handle get plaid identity info for creating customer
        plaid_identity = PlaidService.account_identity(account.plaid_token, account.uid)

        if plaid_identity
          account.plaid_identity = plaid_identity
          if account.is_a?(SourceAccount)
            user_profile = account.user.profile || account.user.build_profile
            account.plaid_identity.profile_info.each do |k, v|
              user_profile.public_send(:"#{k}=", v) if user_profile.public_send(:"#{k}").blank?
            end
            user_profile.save! if user_profile.changed?
          end
        end
        account.save! if account.changed?
      end
    end
  end
end
