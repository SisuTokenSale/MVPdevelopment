class UsersController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :get_token

  def show
  end

  def edit
  end

  def update
    current_user.update_attributes!(strategy: user_params[:strategy])
    redirect_to user_url
  end

  def get_token
    exchange_token_response = $plaid.item.public_token.exchange(params['public_token'])
    access_token = exchange_token_response['access_token']

    # client.processor.dwolla.processor_token.create(access_token, 'XvwKVA4yWRtV5dKaAVa1h8wv9D4dRgfdg4G9P')
    # processor_token = dwolla_response['processor_token']

    user.update_attributes!(access_token: access_token)
  end

  private

  helper_method :user
  def user
    current_user
  end

  def user_params
    params.require(:user).permit(:strategy)
  end
end
