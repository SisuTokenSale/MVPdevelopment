class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile

  before_validation :convert_dob

  validates :dob, :ssn, presence: true
  validates :dob, date: { before_or_equal_to: proc { 18.years.ago.to_date } }

  delegate :email, to: :user, allow_nil: true

  attr_encrypted :dob, key: :encryption_key, marshal: true, marshaler: DateMarshaler
  attr_encrypted :ssn, key: :encryption_key

  has_one :source_customer, dependent: :destroy
  has_one :invest_customer, dependent: :destroy

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def status
    'ssn_dob_completed' if ssn && dob
  end

  def pending?
    # TODO: have unverified sent to Dwolla customer && !waiting?
    false
  end

  def waiting?
    [ssn, dob, first_name, last_name, zip, street, city, state].detect(&:blank?)
  end

  def approved?
    # TODO: have verified customer & !waiting?
    !waiting?
  end

  private

  def convert_dob
    self.dob = Date.parse(dob) rescue dob
  end
end
