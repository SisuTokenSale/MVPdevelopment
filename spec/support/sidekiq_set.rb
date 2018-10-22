require 'sidekiq/testing'

Sidekiq::Testing.fake!
Sidekiq::Testing.inline!
Sidekiq::Logging.logger = nil

RSpec::Sidekiq.configure do |config|
  config.clear_all_enqueued_jobs = true
  config.enable_terminal_colours = true
  config.warn_when_jobs_not_processed_by_sidekiq = false
end
