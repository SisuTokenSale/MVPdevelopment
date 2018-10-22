Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = false
  config.action_controller.asset_host = ENV.fetch('ASSET_HOST', ENV.fetch('APPLICATION_HOST'))
  config.active_storage.service = :local
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false

  ENV['APPLICATION_HOST'] = ENV['HEROKU_APP_NAME'] + '.herokuapp.com' if ENV.fetch('HEROKU_APP_NAME', '').include?('staging-pr-')
  config.middleware.use Rack::CanonicalHost, ENV.fetch('APPLICATION_HOST')
  config.middleware.use Rack::Deflater
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=31557600'
  }

  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = { host: ENV.fetch('APPLICATION_HOST') }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS'), # INFO: example: "smtp.sendgrid.net"
    authentication: ENV.fetch('SMTP_AUTH').to_sym,
    domain: ENV.fetch('SMTP_DOMAIN'), # INFO: example: "heroku.com"
    enable_starttls_auto: true,
    password: ENV.fetch('SMTP_PASSWORD'),
    port: ENV.fetch('SMTP_PORT'),
    user_name: ENV.fetch('SMTP_USERNAME')
  }
  config.action_mailer.asset_host = ENV.fetch('ASSET_HOST', ENV.fetch('APPLICATION_HOST'))
  config.force_ssl = true
end
