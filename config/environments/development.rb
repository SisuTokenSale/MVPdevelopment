require 'letter_opener'

ActionMailer::Base.add_delivery_method(
  :letter_opener,
  LetterOpener::DeliveryMethod,
  location: Rails.root.join('tmp', 'letter_opener')
)

Rails.application.configure do
  config.cache_classes = false
  config.eager_load = true
  config.consider_all_requests_local = true
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.cache_store = :memory_store
    config.public_file_server.headers = {
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.active_storage.service = :local

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.assets.debug = true
  config.assets.quiet = true
  config.action_view.raise_on_missing_translations = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.asset_host = 'http://localhost:3000'

  config.action_mailer.preview_path = Rails.root.join('spec', 'mailers', 'previews')
end
