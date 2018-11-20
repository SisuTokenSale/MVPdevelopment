require 'rails_helper'

describe InvestTransaction, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:invest_set_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false, default: InvestTransaction::STATUSES[0]) }
    it { is_expected.to have_db_column(:amount).of_type(:decimal).with_options(null: false, default: InvestSet::MIN_AMOUNT) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:investment_type).of_type(:string) }
    it { is_expected.to have_db_column(:uid).of_type(:string) }
    it { is_expected.to have_db_column(:cancelled_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:invest_set_id) }
  end

  context 'constants' do
    describe 'STATUSES' do
      specify 'exist' do
        expect(InvestTransaction::STATUSES).to match_array(%w[planned pending processed cancelled failed])
      end
    end

    describe 'TYPES' do
      specify 'exist' do
        expect(InvestTransaction::TYPES).to match_array(%w[one_time periodical])
      end
    end
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:invest_set_id) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(InvestSet::MIN_AMOUNT) }
    it { is_expected.to validate_inclusion_of(:investment_type).in_array(InvestTransaction::TYPES) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:invest_set) }
  end

  describe 'delegators' do
    it { should delegate_method(:currency).to(:source_account).with_arguments(allow_nil: true) }
  end
end
