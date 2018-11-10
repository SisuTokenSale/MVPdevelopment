# INFO: Assets
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# INFO: Logger Flter
Rails.application.config.filter_parameters += %i[password password_confirmation]

# INFO: Encoding
ActiveSupport::JSON::Encoding.time_precision = 0

# INFO: Cookies
Rails.application.config.action_dispatch.cookies_serializer = :json

# INFO: Rack MiniProfiler
if ENV['RACK_MINI_PROFILER'].to_i.positive?
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end

# INFO: Params Wrapper
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: [:json]
end

ActiveModelSerializers.config.adapter = :json

Recaptcha.configure do |config|
  config.site_key = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
end

Money.locale_backend = :i18n
Money.default_currency = Money::Currency.new('USD')
