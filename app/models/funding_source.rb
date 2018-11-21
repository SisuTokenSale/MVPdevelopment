class FundingSource < ApplicationRecord
  STATUSES = %w[pending processed failed].freeze

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  validates :customer_id, :account_id, :status, presence: true

  belongs_to :customer, inverse_of: :funding_sources
  belongs_to :account

  delegate :currency, to: :account, allow_nil: true
  delegate :user, to: :account, allow_nil: true

  def dwolla_registered?
    uid.present? && link.present?
  end

  def business_name
    "#{account.iso_currency_code} <#{account.account_type}>, #{account.institution}"
  end
end
