require 'rails_helper'

describe InvestSet, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:source_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:invest_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:frequency).of_type(:string).with_options(null: false, default: InvestSet::FREQUENCIES[1]) }
    it { is_expected.to have_db_column(:lowest).of_type(:integer) }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false, default: InvestSet::MIN_AMOUNT) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:source_account_id) }
    it { is_expected.to have_db_index(:invest_account_id) }
  end

  context 'constants' do
    describe 'FREQUENCIES' do
      specify 'exist' do
        expect(InvestSet::FREQUENCIES).to match_array(%w[once daily weekly monthly lowest algo])
      end
    end

    describe 'MIN_AMOUNT' do
      specify 'exist' do
        expect(InvestSet::MIN_AMOUNT).to eq 5.0
      end
    end
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:source_account_id) }
    it { is_expected.to validate_presence_of(:invest_account_id) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(InvestSet::MIN_AMOUNT) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source_account) }
    it { is_expected.to belong_to(:invest_account) }
  end

  let(:user) { create :user, :with_invest_sets }
  let(:invest_set) { user.current_invest_set }
  let(:new_invest_set) { InvestSet.new }

  context 'Instance methods' do
    describe '#ready?' do
      specify 'true if it has ready source & Invest accounts, and if it is not new record' do
        expect(invest_set.ready?).to be true
      end

      specify 'false if source_account not ready?' do
        invest_set.source_account.dwolla_token = nil
        expect(invest_set.ready?).to be_falsy
      end

      specify 'false if invest_account not ready?' do
        invest_set.invest_account.dwolla_token = nil
        expect(invest_set.ready?).to be_falsy
      end

      specify 'false if invest_set is new record' do
        expect(new_invest_set.ready?).to be_falsy
      end
    end
  end
end
