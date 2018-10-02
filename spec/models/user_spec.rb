require 'rails_helper'

describe User, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(null: false, default: '') }
    it { is_expected.to have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: '') }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:sign_in_count).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:inet) }
    it { is_expected.to have_db_column(:access_token).of_type(:string) }
    it { is_expected.to have_db_column(:processor_token).of_type(:string) }
    it { is_expected.to have_db_column(:dwolla_customer_url).of_type(:string) }
    it { is_expected.to have_db_column(:strategy).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
  end

  describe 'validators' do
    it { is_expected.to validate_inclusion_of(:strategy).in_array(User::INVEST_STRATEGIES.keys.map(&:to_s)).allow_nil(true) }
  end
end
