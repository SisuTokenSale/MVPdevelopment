class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile

  before_validation :convert_dob

  validates :dob, :ssn, presence: true
  validates :dob, date: true

  attr_encrypted :dob, key: :encryption_key, marshal: true, marshaler: DateMarshaler
  attr_encrypted :ssn, key: :encryption_key

  def status
    'ssn_dob_completed' if ssn && dob
  end

  private

  def convert_dob
    self.dob = Date.parse(dob) rescue dob
  end
end
