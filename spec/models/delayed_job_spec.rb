require 'rails_helper'

class DelayedJob < ActiveRecord::Base; end;

describe DelayedJob, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:priority).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:attempts).of_type(:integer).with_options(null: false, default: 0) }
    it { is_expected.to have_db_column(:handler).of_type(:text).with_options(null: false) }
    it { is_expected.to have_db_column(:last_error).of_type(:text) }
    it { is_expected.to have_db_column(:run_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:locked_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:failed_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:locked_by).of_type(:string) }
    it { is_expected.to have_db_column(:queue).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
    it { is_expected.to have_db_index([:priority, :run_at]) }
  end
end
