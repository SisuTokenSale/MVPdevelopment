require 'rails_helper'
describe FundingSource, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:customer_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:account_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:link).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: 'pending') }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:customer_id) }
    it { is_expected.to have_db_index(:account_id) }
    it { is_expected.to have_db_index(%i[account_id uid]).unique(true) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_presence_of(:account_id) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:account) }
  end

  describe 'delegators' do
    it { should delegate_method(:currency).to(:account).with_arguments(allow_nil: true) }
    it { should delegate_method(:user).to(:account).with_arguments(allow_nil: true) }
  end
end
