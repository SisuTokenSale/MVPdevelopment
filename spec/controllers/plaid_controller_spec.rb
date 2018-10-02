require 'rails_helper'

describe PlaidController, type: :controller do
  let(:user) { create :user }

  before(:each) { sign_in user }

  describe '#apply_token' do
    it 'returns http success' do
      VCR.use_cassette('plaid/exchange') do
        post :apply_token, params: { public_token: PLAID_CFG[:public_token] }
      end
      expect(response).to have_http_status(:success)
      expect(user.reload.access_token).to eq PLAID_CFG[:access_token]
    end
  end
end
