ENV['RACK_ENV'] = 'test'
# ENV['RAILS_ENV'] = 'test'

require File.expand_path('../config/environment', __dir__)
# abort('DATABASE_URL environment variable is set') if ENV['DATABASE_URL']

require 'rspec/rails'
require 'database_cleaner'
require 'shoulda/matchers'
require 'rspec-sidekiq'

Dir[Rails.root.join('spec', '{support,stubs}', '**', '*.rb')].sort.each { |file| require file }

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end

ActiveRecord::Migration.maintain_test_schema!
