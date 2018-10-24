class PlaidController < ApplicationController
  before_action :authenticate_user!

  def create
    param! :public_token, String, required: true
    plaid_token = PlaidService.exchange(public_token: params['public_token'])
    response.set_header('X-PLAID-TOKEN', plaid_token)
    service = PlaidService.new(access_token: plaid_token)
    respond_to do |format|
      format.json { render json: service.accounts }
    end
  end
end
