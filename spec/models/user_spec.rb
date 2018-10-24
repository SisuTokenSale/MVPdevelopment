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
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:email).unique(true) }
    it { is_expected.to have_db_index(:reset_password_token).unique(true) }
  end

  context 'constants' do
    describe 'ROLES' do
      specify 'exist' do
        expect(User::ROLES).to match_array(%w[admin user])
      end
    end
  end

  describe 'associations' do
    it { is_expected.to have_many(:source_accounts) }
    it { is_expected.to have_many(:invest_accounts) }
    it { is_expected.to have_many(:invest_sets) }
  end

  let!(:user) { create :user, :with_invest_sets }
  let(:last_invest_set) { InvestSet.last }
  let(:last_source_account) { user.source_accounts.last }
  let(:last_invest_account) { user.invest_accounts.last }

  context 'Instance methods' do
    describe '#current_invest_set' do
      specify 'return last invest_set' do
        expect(user.current_invest_set.attributes).to match(last_invest_set.attributes)
      end
    end

    describe '#last_source_account' do
      specify 'return last source_account' do
        expect(user.last_source_account.attributes).to match(last_source_account.attributes)
      end
    end

    describe '#last_invest_account' do
      specify 'return last invest_account' do
        expect(user.last_invest_account.attributes).to match(last_invest_account.attributes)
      end
    end
  end
end
