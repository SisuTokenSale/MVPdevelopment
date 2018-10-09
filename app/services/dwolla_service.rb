class DwollaService
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
