# frozen_string_literal: true

Devise.setup do |config|
  config.secret_key = 'c9af93d4128fb7cb3caa27610d1b889fe2e3b85018323c5dd101ea6e4b62d38847beb8948d823de24f674c2fec096825504adb2d1ee6b8d3039d859c6b59512d'
  config.mailer_sender = 'no-reply@sisu.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.allow_unconfirmed_access_for = nil
end
