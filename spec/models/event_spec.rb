require 'rails_helper'

describe Event, type: :model do
  describe 'database' do
    it { is_expected.to have_db_column(:topic).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:resource_id).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:object_class).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:status).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:uid).of_type(:string).with_options(null: false) }
    it { is_expected.to have_db_column(:link).of_type(:string) }
  end

  describe 'indexes' do
    it { is_expected.to have_db_index(:uid).unique(true) }
  end

  describe 'validators' do
    subject { create :event }

    it { is_expected.to validate_presence_of(:topic) }
    it { is_expected.to validate_presence_of(:resource_id) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:link) }
    it { is_expected.to validate_inclusion_of(:object_class).in_array(Event::OBJECT_CLASSES) }
    it { is_expected.to validate_uniqueness_of(:uid) }
  end
end
