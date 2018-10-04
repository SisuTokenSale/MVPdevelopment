require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create :user }

  describe 'GET #show' do
    it 'returns http success' do
      sign_in user
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      sign_in user
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #update' do
    it 'returns http success' do
      sign_in user
      put :update, params: { user: { strategy: 'daily' } }
      expect(response).to redirect_to(user_url)
    end
  end
end
