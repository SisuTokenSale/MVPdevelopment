class PlaidController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :apply_token

  def apply_token
    access_token = PlaidService.new.exchange(public_token: params['public_token'])
    # INFO:
    # client.processor.dwolla.processor_token.create(access_token, 'XvwKVA4yWRtV5dKaAVa1h8wv9D4dRgfdg4G9P')
    # processor_token = dwolla_response['processor_token']
    current_user.update!(access_token: access_token)
  end
end
