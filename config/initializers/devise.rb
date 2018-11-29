# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = ENV['SECRET_KEY_BASE']
  config.mailer_sender = "no-reply@#{ENV['APPLICATION_HOST']}"
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  # TODO: Should be Filtered emails like admin+1@gmail.com
  config.email_regexp = URI::MailTo::EMAIL_REGEXP
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
end
