class DwollaService
  class << self
    def client
      dwolla.auths.client
    end

    private_class_method

    def dwolla
      @dwolla ||= DwollaV2::Client.new(
          key: ENV['DWOLLA_APP_KEY'],
          secret: ENV['DWOLLA_APP_SECRET']
      ) do |config|
        config.environment = ENV['DWOLLA_ENV'].to_sym
      end
    end
  end
end
