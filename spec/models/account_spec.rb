require 'rails_helper'

describe Account, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:plaid_token).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:dwolla_token).of_type(:string) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:balance).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:institution).of_type(:string) }
    it { is_expected.to have_db_column(:account_type).of_type(:string) }
    it { is_expected.to have_db_column(:iso_currency_code).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[plaid_token uid dwolla_token]).unique(true) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:plaid_token) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
