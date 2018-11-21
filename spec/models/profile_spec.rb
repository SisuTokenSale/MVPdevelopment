require 'rails_helper'

describe Profile, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:first_name).of_type(:string) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:street).of_type(:string) }
    it { is_expected.to have_db_column(:city).of_type(:string) }
    it { is_expected.to have_db_column(:state).of_type(:string) }
    it { is_expected.to have_db_column(:zip).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_dob).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_dob_iv).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_ssn).of_type(:string) }
    it { is_expected.to have_db_column(:encrypted_ssn_iv).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'delegators' do
    it { should delegate_method(:email).to(:user).with_arguments(allow_nil: true) }
  end
end
