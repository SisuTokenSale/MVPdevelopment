require 'rails_helper'

describe Account, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false, foreign_key: true) }
    it { is_expected.to have_db_column(:account_id).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:balance).of_type(:decimal).with_options(null: false, default: 0.0) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_index(:user_id) }
  end

  describe 'validators' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:account_id) }
    it { is_expected.to validate_presence_of(:balance) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end
end
