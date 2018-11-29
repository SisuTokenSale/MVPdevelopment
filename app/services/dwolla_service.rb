class DwollaService
  attr_reader :error

  def app_token
    self.class.client.auths.client
  end

  def webhooks
    @webhooks ||= app_token.get 'webhook-subscriptions'
    # INFO: Can be using return [] if @webhooks.total.zero?

    @webhooks['_embedded']['webhook-subscriptions'].map do |ws|
      {
        link: ws['_links']['self']['href'],
        uid: ws['id'],
        url: ws['url'],
        paused: ws['paused'],
        created_at: ws['created']
      }
    end
  rescue DwollaV2::Error => error
    @error = error
    []
  rescue StandardError => error
    @error = error
    []
  end

  def init_webhook(opts = {})
    raise(ArgumentError, 'Option :body required!') unless opts[:body]

    subscription = app_token.post 'webhook-subscriptions', request_body
    subscription.response_headers[:location]
  rescue DwollaV2::ValidationError => error
    @error = error
    nil
  end

  def cancel_transaction(opts = {})
    raise(ArgumentError, 'Option :body required!') unless opts[:body]
    raise(ArgumentError, 'Option :link required!') unless opts[:link]

    transfer = app_token.post opts[:link], opts[:body]
    transfer.status
  rescue DwollaV2::ValidationError => error
    @error = error
    nil
  end

  def init_transaction(opts = {})
    raise(ArgumentError, 'Option :body required!') unless opts[:body]

    transfer = app_token.post 'transfers', opts[:body]
    transfer.response_headers[:location]
  rescue DwollaV2::ValidationError => error
    @error = error
    nil
  end

  # INFO: Return funding_source link
  def register_funding_source(opts = {})
    raise(ArgumentError, 'Option :customer_link required!') unless opts[:customer_link]

    raise(ArgumentError, 'Option :business_name required!') unless opts[:business_name]

    raise(ArgumentError, 'Option :dwolla_token required!') unless opts[:dwolla_token]

    request_body = {
      plaidToken: opts[:dwolla_token],
      name: opts[:business_name]
    }
    funding_source = app_token.post "#{opts[:customer_link]}/funding-sources", request_body
    funding_source.response_headers[:location]
  rescue DwollaV2::DuplicateResourceError => error
    @error = error
    if funding_source_exist?
      update_funding_source(link: funding_source_link_from_error, body: { name: request_body[:name] })
      return funding_source_link_from_error
    end
  end

  def funding_source_exist?
    error&.code == 'DuplicateResource' && error._links
  end

  def funding_source_link_from_error
    error._links['about']['href']
  end

  def update_funding_source(opts = {})
    raise(ArgumentError, 'Option :link required!') unless opts[:link]

    raise(ArgumentError, 'Option :body required!') unless opts[:body]

    app_token.post opts[:link], opts[:body]
  end

  # INFO: Return customer link
  def register_customer(opts = {})
    customer = app_token.post 'customers', opts[:request_body]
    customer.response_headers[:location]
  rescue DwollaV2::Error => error
    @error = error
    nil
  end

  # INFO: Return customer UID
  def update_customer(opts = {})
    raise(ArgumentError, 'Option :link required!') unless opts[:link]

    raise(ArgumentError, 'Option :body required!') unless opts[:body]

    customer = app_token.post opts[:link], opts[:body]
    customer.id
  rescue DwollaV2::Error => error
    @error = error
    nil
  end

  class << self
    def client
      @client ||= DwollaV2::Client.new(
        key: ENV['DWOLLA_APP_KEY'],
        secret: ENV['DWOLLA_APP_SECRET']
      ) do |config|
        config.environment = ENV['DWOLLA_ENV'].to_sym
      end
    end
  end
end
