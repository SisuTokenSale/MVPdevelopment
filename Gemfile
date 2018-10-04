source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'autoprefixer-rails'
gem 'flutie'
gem 'honeybadger'
gem 'jquery-rails'
gem 'pg', '~> 0.18'
gem 'puma'
gem 'rack-canonical-host'
gem 'rails', '~> 5.2.1'
gem 'recipient_interceptor'
gem 'sass-rails', '~> 5.0'
gem 'skylight'
gem 'sprockets', '>= 3.0.0'
gem 'title'
gem 'uglifier'
gem 'bootsnap', require: false
gem 'devise'
gem 'bootstrap', '~> 4.1.3'
gem 'devise-bootstrapped', github: 'king601/devise-bootstrapped', branch: 'bootstrap4'
gem 'high_voltage'
gem 'bourbon', '~> 5.0'
gem 'neat', '~> 2.1'
gem 'simple_form'
gem 'delayed_job_active_record'
gem 'plaid'
gem 'dwolla_v2', '~> 2.0'
gem 'cancancan'

group :development do
  gem 'listen'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'web-console'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'suspenders'
  gem 'rspec-rails', '~> 3.6'
  gem 'bullet'
  gem 'rubocop'
end

group :test do
  gem 'formulaic'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'capybara-selenium'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'vcr'
end

gem 'rack-timeout', group: :production
