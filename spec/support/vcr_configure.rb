require 'vcr'

PLAID_CFG = {
  public_token: "public-#{ENV['PLAID_ENV']}-f43cdaa3-af76-4b03-94fb-5aeb3c148ee7",
  access_token: "access-#{ENV['PLAID_ENV']}-6a505352-6c5c-45de-b1a1-c9764ed7d18b",
  username: 'user_good',
  password: 'user_pass',
  insitution_id: 'ins_109508',
  start_date: '2018-09-14',
  end_date: '2018-10-14',
  source_account_id: 'zLVz3PyjXgFn81x4X4jpfKE71NeEjNtoVdjj8',
  invest_account_id: 'BXAk7GeVbaiKWky545vxHg6lprB6ErIwBvaa6'
}.freeze

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join('spec', 'vcr')

  config.hook_into :webmock
  config.ignore_localhost = true
  config.filter_sensitive_data('PLAID_CLIENT_ID') { ENV['PLAID_CLIENT_ID'] }
  config.filter_sensitive_data('PLAID_SECRET') { ENV['PLAID_SECRET'] }
  config.filter_sensitive_data('PLAID_PUBLIC_KEY') { ENV['PLAID_PUBLIC_KEY'] }
  config.filter_sensitive_data('PLAID_ENV') { ENV['PLAID_ENV'] }
  config.filter_sensitive_data('PLAID_PUBLIC_TOKEN') { PLAID_CFG[:public_token] }
  config.filter_sensitive_data('PLAID_ACCESS_TOKEN') { PLAID_CFG[:access_token] }
  config.filter_sensitive_data('PLAID_USERNAME') { PLAID_CFG[:username] }
  config.filter_sensitive_data('PLAID_PASSWORD') { PLAID_CFG[:password] }
  config.filter_sensitive_data('PLAID_INSTITUTION_ID') { PLAID_CFG[:insitution_id] }
  config.filter_sensitive_data('PLAID_START_DATE') { PLAID_CFG[:start_date] }
  config.filter_sensitive_data('PLAID_END_DATE') { PLAID_CFG[:end_date] }
  config.default_cassette_options = { record: :none, match_requests_on: %i[method uri body] }

  config.around_http_request do |request|
    case request&.uri
    when 'https://sandbox.plaid.com/identity/get'
      VCR.use_cassette('plaid/identity', &request)
    when 'https://sandbox.plaid.com/auth/get'
      VCR.use_cassette('plaid/auth', &request)
    when 'https://sandbox.plaid.com/item/public_token/exchange'
      VCR.use_cassette('plaid/exchange', &request)
    when 'https://sandbox.plaid.com/transactions/get'
      VCR.use_cassette('plaid/transactions', &request)
    end
  end
end
