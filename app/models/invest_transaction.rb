class InvestTransaction < ApplicationRecord
  STATUSES = %w[planned pending processed cancelled failed].freeze
  TYPES = %w[one_time periodical].freeze

  attribute :status, :string, default: STATUSES[0]
  attribute :amount, :decimal, default: InvestSet::MIN_AMOUNT

  enum status: STATUSES.each_with_object({}) { |val, hash| hash[val.to_sym] = val }

  validates :investment_type, inclusion: { in: TYPES }
  validates :amount, numericality: { greater_than_or_equal_to: InvestSet::MIN_AMOUNT }

  validates :invest_set_id, presence: true

  belongs_to :invest_set

  has_one :source_account, through: :invest_set
  has_one :invest_account, through: :invest_set

  scope :for_cancelling, -> { where(status: %w[planned pending]) }

  delegate :currency, to: :source_account, allow_nil: true

  before_create :assign_iso_currency_code

  def human_amount
    Money.new(amount * 100, iso_currency_code).format
  end

  def can_be_cancelled?
    planned? || pending?
  end

  def cancelled!
    self.cancelled_at = Time.current if planned?
    super
    # TODO: Run inside Job if pending?
    # - request to dwolla for discard transaction
    # - Set cancelled_at after up operations
    # INFO: All manipukations should be in Transaction block
  end

  def correlation_id
    Digest::MD5.hexdigest "#{invest_set_id}-#{id}-#{amount}-#{iso_currency_code}"
  end

  def cancelled?
    cancelled_at && super
  end

  private

  def assign_iso_currency_code
    self.iso_currency_code = currency.iso_code
  end
end
