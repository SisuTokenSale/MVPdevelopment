class Profile < ApplicationRecord
  attr_accessor :documents

  belongs_to :user, inverse_of: :profile

  validates :first_name, :last_name, :city, :street, :birth_date, :zip, :ssn, presence: true
  validates :state, format: { with: /\A[A-Z]{2}\z/i, message: 'State must be 2-letter abbreviation' }
  # validates :zip, format: { with: /\A[0-9]{5}\z/i } # TODO: filter only US codes

  def customer_uid
    return unless dwolla_customer_uid.present?

    dwolla_customer_uid.split('/')[-1]
  end
end
