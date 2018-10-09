require 'rails_helper'

describe InvestSet, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:source_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:invest_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:strategy).of_type(:string) }
    it { is_expected.to have_db_column(:frequency).of_type(:string).with_options(null: false, default: 'once') }
    it { is_expected.to have_db_column(:lowest).of_type(:integer) }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:source_account_id) }
    it { is_expected.to have_db_index(:invest_account_id) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:source_account_id) }
    it { is_expected.to validate_presence_of(:invest_account_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source_account) }
    it { is_expected.to belong_to(:invest_account) }
  end
end
