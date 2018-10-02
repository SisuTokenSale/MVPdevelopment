require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  let!(:user) { create :user }

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

  describe "GET #show" do
    it "returns http success" do
      # stub_plaid_post
      sign_in user
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:success)
    end
  end
end
