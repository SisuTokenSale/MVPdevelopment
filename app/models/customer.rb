class Customer < ApplicationRecord
  # INFO: https://docsv2.dwolla.com/#customers
  STATUSES = %w[unverified created verify_needed verify_uploaded verify_failed verify_approved verified suspended activated deactivated].freeze
  TYPES = %w[unverified personal business receive-only].freeze

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  before_save do
    self.uid ||= link.split('/').last if link.present?
  end

  validates :customer_type, inclusion: { in: TYPES }
  validates :profile_id, :status, :customer_type, presence: true
  validates :profile_id, uniqueness: { scope: %i[uid] }

  belongs_to :profile
  has_many :funding_sources, dependent: :destroy

  delegate :email, to: :profile, allow_nil: true
  delegate :user, to: :profile, allow_nil: true

  def dwolla_registered?
    uid.present? && link.present?
  end

  def verified!
    super
    NoticeService.customer(self, :verified)
  end

  def suspended!
    super
    NoticeService.customer(self, :suspended)
  end

  def verify_needed!
    super
    NoticeService.customer(self, :verify_needed)
  end

  def verify_uploaded!
    super
    NoticeService.customer(self, :verify_uploaded)
  end

  def verify_approved!
    super
    NoticeService.customer(self, :verify_approved)
  end

  def verify_failed!
    super
    NoticeService.customer(self, :verify_failed)
  end

  def business_name
    raise NoMethodError, 'business_name doesn\'t exist'
  end
end
