require 'rails_helper'

describe Customer, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:profile_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:link).of_type(:string) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: 'unverified') }
    it { is_expected.to have_db_column(:customer_type).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:profile_id) }
    it { is_expected.to have_db_index(%i[profile_id uid]).unique(true) }
  end

  describe 'validators' do
    subject { create :customer, :with_profile }

    it { is_expected.to validate_presence_of(:profile_id) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:customer_type) }
    it { is_expected.to validate_inclusion_of(:customer_type).in_array(Customer::TYPES) }
    it { is_expected.to validate_uniqueness_of(:profile_id).scoped_to(%i[uid]) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:profile) }
    it { is_expected.to have_many(:funding_sources) }
  end

  describe 'delegators' do
    it { should delegate_method(:email).to(:profile).with_arguments(allow_nil: true) }
    it { should delegate_method(:user).to(:profile).with_arguments(allow_nil: true) }
  end
end
