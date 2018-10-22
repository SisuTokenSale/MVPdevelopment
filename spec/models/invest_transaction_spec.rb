require 'rails_helper'

describe InvestTransaction, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:invest_set_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:source_account_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:invest_account_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: 'planned') }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:invest_set_id) }
    it { is_expected.to have_db_index(:source_account_id) }
    it { is_expected.to have_db_index(:invest_account_id) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:invest_set_id) }
    it { is_expected.to validate_presence_of(:source_account_id) }
    it { is_expected.to validate_presence_of(:invest_account_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:invest_set) }
    it { is_expected.to belong_to(:source_account) }
    it { is_expected.to belong_to(:invest_account) }
  end
end
