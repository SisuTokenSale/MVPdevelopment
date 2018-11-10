source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.1'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'redis', '~> 4.0'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rails_param'
gem 'rack-canonical-host'

gem 'jquery-rails'
gem 'pg', '~> 0.18'
gem 'devise'
gem 'simple_form'
gem 'plaid'
gem 'dwolla_v2', '~> 2.0'
gem 'cancancan'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'active_model_serializers', '~> 0.10.0'
gem 'recaptcha'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'money'

gem 'loofah', '>= 2.2.3'

# INFO: Debug tools
gem 'rollbar'

# TODO: Remove after implement new design
gem 'bourbon', '~> 5.0'
gem 'neat', '~> 2.1'
gem 'bootstrap', '~> 4.1.3' # TODO: DON'T REMOVE bootstrap - currently used bootstap grid system & popup
gem 'devise-bootstrapped', github: 'king601/devise-bootstrapped', branch: 'bootstrap4'

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rubocop'
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'letter_opener', github: 'ryanb/letter_opener'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'rspec-rails', '~> 3.6'
  gem 'timecop'
  gem 'webmock'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'vcr'
  gem 'simplecov', require: false
end

gem 'rails_admin', '~> 1.3'
gem 'jquery-ui-rails'
