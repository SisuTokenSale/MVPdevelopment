require 'rails_helper'

describe AccountTransaction, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:account_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:uid).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:processed_on).of_type(:date).with_options(null: false) }
    it { is_expected.to have_db_column(:iso_currency_code).of_type(:string) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:deposit).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:credit).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:account_id) }
    it { is_expected.to have_db_index(%i[account_id uid]).unique(true) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:account_id) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:processed_on) }
    it { is_expected.to validate_numericality_of(:deposit) }
    it { is_expected.to validate_numericality_of(:credit) }
    # TODO: Should be fixed
    # it { is_expected.to validate_uniqueness_of(:uid) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:account) }
  end
end
