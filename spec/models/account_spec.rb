require 'rails_helper'

describe Account, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:plaid_token).of_type(:string).with_options(null: true) }
    it { is_expected.to have_db_column(:dwolla_token).of_type(:string).with_options(null: true) }
    it { is_expected.to have_db_column(:type).of_type(:string) }
    it { is_expected.to have_db_column(:balance).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:institution).of_type(:string) }
    it { is_expected.to have_db_column(:institution_id).of_type(:string) }
    it { is_expected.to have_db_column(:mask).of_type(:string) }
    it { is_expected.to have_db_column(:account_type).of_type(:string) }
    it { is_expected.to have_db_column(:iso_currency_code).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:plaid_identity).of_type(:text) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_index(%i[plaid_token uid dwolla_token]).unique(true) }
  end

  context 'attributes' do
    describe 'accessors' do
      it { is_expected.to respond_to(:public_token) }
      it { is_expected.to respond_to(:'public_token=') }
    end
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:account_transactions) }
  end

  let(:user) { create :user, :with_invest_sets }
  let(:account) { build :account, user: user }
  let(:usd_account) { build :account, :with_usd }
  let(:eur_account) { build :account, :with_eur }
  let(:gbp_account) { build :account, :with_gbp }

  context 'Instance methods' do
    describe '#currency' do
      specify 'return currency by iso_currency_code' do
        expect(usd_account).is_a? Money::Currency
        expect(usd_account.currency.symbol).to eq('$')
        expect(eur_account.currency.symbol).to eq('€')
        expect(gbp_account.currency.symbol).to eq('£')
      end
    end
  end

  context 'Private methods' do
    describe '#assign_to_invest_set' do
      specify 'should be raised' do
        expect { account.send(:assign_to_invest_set) }.to raise_error(NoMethodError, 'assign_to_invest_set doesn\'t exist')
      end
    end

    describe '#current_invest_set' do
      specify 'should be return user current_invest_set' do
        expect(account.send(:current_invest_set)).to eq(user.current_invest_set)
      end
    end

    # TODO: Should be covered like callback in Invest and Source account models
    # describe '#dwolla_fetch_token' do
    #   specify 'should be return DwollaFetchTokensJob' do
    #     expect(account).to respond_to(:dwolla_fetch_token)
    #   end
    # end
  end
end
