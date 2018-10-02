class PlaidService
  attr_reader :access_token

  def initialize(opts = {})
    @access_token = opts[:access_token]
  end

  def accounts
    raise(ArgumentError, 'access_token required!') unless access_token

    self.class
        .client.auth.get(access_token)
        .with_indifferent_access[:accounts].map { |acc| OpenStruct.new(acc) }
  end

  def account_data(opts = {})
    raise(ArgumentError, 'Option :account_id required!') unless opts[:account_id]

    accounts.detect { |acc| acc.account_id == opts[:account_id] }
  end

  def exchange(opts = {})
    raise(ArgumentError, 'Option :public_token required!') unless opts[:public_token]

    self.class
        .client.item.public_token.exchange(opts[:public_token])['access_token']
  end

  def balance(opts = {})
    raise(ArgumentError, 'Option :account_id required!') unless opts[:account_id]

    accounts.detect { |acc| acc.account_id == opts[:account_id] }[:balances][:current]
  end

  def transactions(opts = {})
    raise(ArgumentError, 'access_token required!') unless access_token

    from = opts[:from] || 6.months.ago
    to   = opts[:to]   || Date.current
    trs = self.class
              .client.transactions
              .get(access_token, from, to)[:transactions]
    # INFO: Filters
    trs.select { |trn| trn[:account_id] == opts[:account_id] } if opts[:account_id]
    trs
  end

  class << self
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
