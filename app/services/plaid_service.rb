class PlaidService
  attr_reader :access_token

  ACCOUNT_TYPES = %i[current available].freeze

  IDENTITY_ATTRIBUTES = %i[addresses emails names phone_numbers].freeze

  def initialize(opts = {})
    @access_token = opts[:access_token]
  end

  def accounts
    raise(ArgumentError, 'access_token required!') unless access_token

    auth_res = self.class.client.auth.get(access_token)
    @accounts ||= auth_res.with_indifferent_access[:accounts].map do |acc|
      attrs = acc.slice(:name, :official_name, :type, :subtype, :iso_currency_code)
      attrs[:uid] = acc[:account_id]
      attrs[:available_balance] = acc[:balances][:available] || 0.0
      attrs[:current_balance] = acc[:balances][:current] || 0.0
      attrs[:iso_currency_code] = acc[:balances][:iso_currency_code]
      PlaidAccount.new(attrs)
    end
  rescue StandardError => error
    raise AppExceptions::PlaidError, error
  end

  def account_data(opts = {})
    raise(ArgumentError, 'Option :uid required!') unless opts[:uid]

    accounts.detect { |acc| acc.uid == opts[:uid] }
  end

  def balance(opts = {})
    raise(ArgumentError, 'Option :uid required!') unless opts[:uid]

    type = opts[:type] || :current

    raise(ArgumentError, "Option :type should be in range [#{ACCOUNT_TYPES.join(',')}]!") unless type.in?(ACCOUNT_TYPES)

    accounts.detect { |acc| acc.uid == opts[:uid] }[:balances][type]
  end

  def transactions(opts = {})
    raise(ArgumentError, 'access_token required!') unless access_token

    from = opts[:from] || 6.months.ago
    to   = opts[:to]   || Date.current
    trs = self.class
              .client.transactions
              .get(access_token, from, to)[:transactions]
    # INFO: Filters
    trs.select { |trn| trn[:account_id] == opts[:uid] } if opts[:uid]
    trs
  end

  class << self
    def account_identity(plaid_token, uid)
      raise(ArgumentError, 'plaid_token required!') unless plaid_token

      raise(ArgumentError, 'uid required!') unless uid

      response = client.identity.get(plaid_token).with_indifferent_access
      mask = response[:accounts].detect { |acc| acc[:account_id] == uid }[:mask]
      idty_attrs = response[:identity].slice(*IDENTITY_ATTRIBUTES)
      address = idty_attrs[:addresses].detect { |addr| addr[:accounts].detect { |el| el.include?(mask) } }[:data]
      email = idty_attrs[:emails].detect { |h| h[:primary] == true }[:data]
      phones = idty_attrs[:phone_numbers].map { |pn| pn[:data] }
      PlaidIdentity.new(names: idty_attrs[:names], address: address, email: email, phones: phones)
    end

    def fetch_dwolla_processor_token(plaid_token, uid)
      raise(ArgumentError, 'plaid_token required!') unless plaid_token

      raise(ArgumentError, 'uid required!') unless uid

      client.processor
            .dwolla
            .processor_token
            .create(plaid_token, uid)['processor_token']
    rescue StandardError => error
      # TODO: Should be fixed raise AppExceptions::PlaidError, error
      # Rollbar.error(error) && nil
      raise AppExceptions::PlaidError, error
    end

    def institution_by_id(opts = {})
      raise(ArgumentError, 'Option :id required!') unless opts[:id]

      client.institutions.get_by_id(opts[:id]).with_indifferent_access[:institution]
    end

    def exchange(opts = {})
      raise(ArgumentError, 'Option :public_token required!') unless opts[:public_token]

      client.item.public_token.exchange(opts[:public_token])['access_token']
    end

    def client
      @client ||= Plaid::Client.new(
        env: ENV['PLAID_ENV'],
        client_id: ENV['PLAID_CLIENT_ID'],
        secret: ENV['PLAID_SECRET'],
        public_key: ENV['PLAID_PUBLIC_KEY']
      )
    end
  end
end
