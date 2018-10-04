require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:user) { create :user, access_token: PLAID_CFG[:access_token] }
  let!(:source_account) { create :source_account, user: user, account_id: PLAID_CFG[:source_account_id] }
  let!(:invest_account) { create :invest_account, user: user, account_id: PLAID_CFG[:invest_account_id] }
  # describe "#index" do
  #   it "returns http success" do
  #     sign_in user
  #     get :index
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "#create" do
  #   it "returns http success" do
  #     sign_in user
  #     post :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe "#delete" do
  #   it "returns http success" do
  #     sign_in user
  #     delete :delete
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  describe '#show' do
    it 'returns http success for invest_account' do
      sign_in user
      VCR.use_cassette('plaid/auth') do
        VCR.use_cassette('plaid/transactions', match_requests_on: %i[method uri]) do
          get :show, params: { id: source_account.id, type: 'Invest' }
        end
      end
      expect(response).to have_http_status(:success)
    end

    it 'returns http success for invest_account' do
      sign_in user
      VCR.use_cassette('plaid/auth') do
        VCR.use_cassette('plaid/transactions', match_requests_on: %i[method uri]) do
          get :show, params: { id: invest_account.id, type: 'Invest' }
        end
      end
      expect(response).to have_http_status(:success)
    end
  end
end
