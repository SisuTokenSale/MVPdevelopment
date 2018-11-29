require 'rails_helper'

describe InvestSet, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:source_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:invest_account_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:frequency).of_type(:string).with_options(null: false, default: InvestSet::FREQUENCIES[0]) }
    it { is_expected.to have_db_column(:lowest).of_type(:integer) }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false, default: InvestSet::MIN_AMOUNT) }
    it { is_expected.to have_db_column(:rel_min_balance).of_type(:decimal).with_options(null: false, default: 5.0) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: InvestSet::STATUSES[0]) }
    it { is_expected.to have_db_column(:cancelled_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(:source_account_id) }
    it { is_expected.to have_db_index(:invest_account_id) }
  end

  context 'constants' do
    describe 'FREQUENCIES' do
      specify 'exist' do
        expect(InvestSet::FREQUENCIES).to match_array(%w[daily weekly monthly lowest algo])
      end
    end

    describe 'MIN_AMOUNT' do
      specify 'exist' do
        expect(InvestSet::MIN_AMOUNT).to eq 5.0
      end
    end

    describe 'MAX_AMOUNT' do
      specify 'exist' do
        expect(InvestSet::MAX_AMOUNT).to eq 5000.0
      end
    end
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:source_account_id) }
    it { is_expected.to validate_presence_of(:invest_account_id) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(InvestSet::MIN_AMOUNT) }
    it { is_expected.to validate_numericality_of(:rel_min_balance).is_greater_than_or_equal_to(5.0).is_less_than_or_equal_to(90) }
    it { is_expected.to validate_inclusion_of(:frequency).in_array(InvestSet::FREQUENCIES) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:source_account) }
    it { is_expected.to belong_to(:invest_account) }
  end

  describe 'delegators' do
    it { should delegate_method(:currency).to(:source_account).with_arguments(allow_nil: true) }
  end

  let(:user) { create :user }
  let(:invest_set) { create :invest_set, :with_accounts, user: user }
  let(:new_invest_set) { InvestSet.new }

  context 'Instance methods' do
    describe '#ready?' do
      specify 'true if it has ready source & Invest accounts, and if it is not new record and has dwolla_token' do
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
