require 'rails_helper'

describe 'PLaidService' do
  context 'Init' do
    before do
      PlaidService.new
    end
    it 'client should be created' do
      expect(PlaidService.client).to_not be_nil
      expect(PlaidService.client).is_a?(Plaid::Client)
    end
  end
end
