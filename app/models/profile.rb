class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile

  validates :first_name, :last_name, :ssn, presence: true
end
