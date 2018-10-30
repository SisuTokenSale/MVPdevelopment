class Profile < ApplicationRecord
  attr_accessor :documents

  belongs_to :user, inverse_of: :profile

  validates :first_name, :last_name, :ssn, presence: true
end
