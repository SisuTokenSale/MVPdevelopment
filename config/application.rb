require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Sisu
  class Application < Rails::Application
    config.assets.quiet = true
    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.load_defaults 5.2
    config.generators.system_tests = nil
    config.active_job.queue_adapter = :sidekiq
    config.assets.initialize_on_precompile = false
  end
end
