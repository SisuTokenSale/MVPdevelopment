require 'rails_helper'

describe 'DwollaService' do
  context 'Init' do
    before do
      DwollaService.new
    end
    it 'client should be created' do
      expect(DwollaService.client).to_not be_nil
      expect(DwollaService.client).is_a?(DwollaV2::Client)
    end
  end
end
